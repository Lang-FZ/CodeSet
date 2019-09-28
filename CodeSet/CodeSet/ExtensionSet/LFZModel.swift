//
//  LFZModel.swift
//  OnceNaive_Swift
//
//  Created by LangFZ on 2019/9/27.
//  Copyright © 2019 LangFZ. All rights reserved.
//

import UIKit

private var replacedKeyFromPropertyNameIdentifier = "replacedKeyFromPropertyNameIdentifier"
private var ignoredPropertyNamesIdentifier = "ignoredPropertyNamesIdentifier"
private var propertyToClassIdentifier = "propertyToClassIdentifier"
private var propertyToClassInArrayIdentifier = "propertyToClassInArrayIdentifier"
private var referenceReplacedKeyIdentifier = "referenceReplacedKeyIdentifier"

extension NSObject {

    // MARK: 替换属性名
    @objc public var replacedKeyFromPropertyName : [String : Any] {
        get {
            return objc_getAssociatedObject(self, &replacedKeyFromPropertyNameIdentifier) as? [String : Any] ?? [:]
        }
    }
    // MARK: 忽略的属性名
    @objc public var ignoredPropertyNames : [String] {
        get {
            return objc_getAssociatedObject(self, &ignoredPropertyNamesIdentifier) as? [String] ?? []
        }
    }
    // MARK: 指定属性为类
    @objc public var propertyToClass : [String : NSObject.Type] {
        get {
            return objc_getAssociatedObject(self, &propertyToClassIdentifier) as? [String : NSObject.Type] ?? [:]
        }
    }
    // MARK: 指定属性为数组中的类
    @objc public var propertyToClassInArray : [String : NSObject.Type] {
        get {
            return objc_getAssociatedObject(self, &propertyToClassInArrayIdentifier) as? [String : NSObject.Type] ?? [:]
        }
    }
    // MARK: 模型转字典时是否遵循自定义映射
    @objc public var referenceReplacedKey : Bool {
        get {
            return objc_getAssociatedObject(self, &referenceReplacedKeyIdentifier) as? Bool ?? false
        }
    }
    
    
    // MARK: 赋值主方法 字典转模型
    public func LFZ_objectSetKeyValues(_ keyValues : Any) -> Self {
        
        let JsonData = LFZ_JSONObject(keyValues)
        let (keys,_) = LFZ_Properties()
        
        for key in keys {
            
            // MARK: 如果忽略这个元素就跳过
            let isContains = ignoredPropertyNames.contains { (ignored) -> Bool in
                return key == ignored
            }
            if isContains { continue }
            
            // MARK: 替换属性名
            var real_key = key
            if let replaceKey:String = replacedKeyFromPropertyName[key] as? String {
                real_key = replaceKey
            }
            
            if let replace_class = propertyToClass[real_key] {
                // MARK: 某一个属性为 模型
                if let values:[String:Any] = JsonData[real_key] as? [String:Any],
                    let class_instance:NSObject = class_createInstance(replace_class, 0) as? NSObject {
                    
                    let model = class_instance.LFZ_objectSetKeyValues(values)
                    setValue(model, forKey: real_key)
                }
                
            } else if let replace_arr_class = propertyToClassInArray[real_key] {
                // MARK: 某一个属性为 模型数组
                if let valuesArr:[Any] = JsonData[real_key] as? [Any] {
                    
                    var model_arr:[Any] = []
                    for values in valuesArr {
                    
                        if let class_instance:NSObject = class_createInstance(replace_arr_class, 0) as? NSObject {
                            let model = class_instance.LFZ_objectSetKeyValues(values)
                            model_arr.append(model)
                        }
                    }
                    setValue(model_arr, forKey: real_key)
                    
                } else {
                    // 值为空也赋值 因为没有初始化 转回字典取到未初始化会崩溃
                    setValue([], forKey: real_key)
                }
                
            } else {
                //TODO: 少一个判断 如果是其他模型做处理
                if let value = JsonData[real_key] {
                    // 屏蔽基础类型赋值 null 引发崩溃
                    if value is NSNull { continue }
                    
                    // MARK: 普通赋值
                    setValue(value, forKey: key)
                }
            }
        }
        
        return self
    }
    
    // MARK: 转字典
    public func LFZ_KeyValues() -> AnyObject {
        
        // 过滤掉 NSNull
        if (self is NSNull) { return NSDictionary() }
        
        // 如果自己不是模型类, 那就返回自己
        if self is URL ||
            self is Date ||
            self is NSValue ||
            self is Data ||
            self is Error ||
            self is Array<Any> ||
            self is Dictionary<String,Any> ||
            self is String ||
            self is NSAttributedString {
            
            return self
        }
        
        // 模型转字典
        var keyValues:[String:Any] = [:]
        let (keys,_) = LFZ_Properties()
        
        for key in keys {
            
            // MARK: 如果忽略这个元素就跳过
            let isContains = ignoredPropertyNames.contains { (ignored) -> Bool in
                return key == ignored
            }
            if isContains { continue }
            
            // MARK: 替换属性名
            var real_key = key
            if let replaceKey:String = replacedKeyFromPropertyName[key] as? String {
                real_key = replaceKey
            }
            
            // value 不为空
            guard let value = self.value(forKey: key) else { continue }
            
            // null 不记录
            if value is NSNull { continue }
            
            if propertyToClassInArray[key] != nil {
                // MARK: 某一个属性为 模型数组
                var temp_arr:[AnyObject] = []
                if let value_arr = value as? [NSObject] {
                    if value_arr.count > 0 {
                        for class_value in value_arr {
                            temp_arr.append(class_value.LFZ_KeyValues())
                        }
                        keyValues[real_key] = temp_arr
                    }
                }
                
            } else if propertyToClass[key] != nil {
                // MARK: 某一个属性为 模型
                if let object_value = value as? NSObject {
                    keyValues[real_key] = object_value.LFZ_KeyValues()
                }
                
            } else {
                //TODO: 少一个判断 如果是其他模型做处理
                // 屏蔽基础类型赋值 null 引发崩溃
                if value is NSNull { continue }
                // MARK: 普通赋值
                keyValues[real_key] = value
            }
        }
        
        return keyValues as NSDictionary
    }
    
    // MARK: 获取 属性名 属性描述
    private func LFZ_Properties() -> ([String],[String]) {

        var keys:[String] = []
        var attributes:[String] = []
        
        var count:UInt32 = 0
        if let properties:UnsafeMutablePointer<objc_property_t> = class_copyPropertyList(Self.self, &count) {
            
            for i in 0..<count {
                
                // MARK: 获取属性列表
                let property:objc_property_t = properties[Int(i)]
                
                // 属性名
                guard let property_name = String.init(cString: property_getName(property), encoding: String.Encoding.utf8) else { continue }
                if property_name != "replacedKeyFromPropertyName",
                    property_name != "ignoredPropertyNames",
                    property_name != "propertyToClass",
                    property_name != "propertyToClassInArray",
                    property_name != "referenceReplacedKey" {
                    
                    keys.append(property_name)
                }

                // 属性描述: R read-only  C copy  & retain    N nonatomic     G<name> getter  S<name> setter  D dynamic   W weak  Pproperty   t<encoding> old-style encoding
                guard let propertyAttribute = String.init(cString: property_getAttributes(property)!, encoding: String.Encoding.utf8) else { continue }
                attributes.append(propertyAttribute)
            }
            free(properties)
        }
        return (keys,attributes)
    }
}

// MARK: 解析数据
public func LFZ_JSONObject(_ self:Any) -> AnyObject {
    
    if self is String {
        do {
            return try JSONSerialization.jsonObject(with: (self as? String ?? "").data(using: String.Encoding.utf8) ?? Data(), options: JSONSerialization.ReadingOptions.init(rawValue: 0)) as AnyObject
        } catch {}
    } else if self is Data {
        do {
            return try JSONSerialization.jsonObject(with: (self as? Data ?? Data()), options: JSONSerialization.ReadingOptions.init(rawValue: 0)) as AnyObject
        } catch {}
    }
    
    return (self as? NSObject ?? NSObject()).LFZ_KeyValues()
}
