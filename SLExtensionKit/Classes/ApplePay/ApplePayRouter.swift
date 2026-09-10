//
//  ApplePayRouter.swift
//  Pods
//
//  Created by muwa on 2025/8/25.
//

import Foundation


/// 内购服务统一接口
/// 内部屏蔽了 StoreKit 1 与 StoreKit 2 的差异
@MainActor protocol ApplePayService: AnyObject {
    
    /// 数据回调
    var serviceDelegate: ApplePayServiceDelegate? { get set }
    
    /// 检测是否可以使用内购
    func checkCanPayment() -> Bool
    
    /// 开始监听（注册观察者）
    func start()
    
    /// 开始支付（内部负责获取商品信息并发起购买）
    func startPay(productId: String, orderId: String)
    
    /// 恢复购买
    func restore()
    
    /// 刷新/预加载商品信息（本地缓存，购买时优先使用）
    func reloadProducts(productIds: [String])
    
    /// 获取本地购买凭证
    func getLocalReceiptInfo() -> String?
    
    /// 取消
    func cancel()
}


/// 内购服务回调
@MainActor protocol ApplePayServiceDelegate: AnyObject {
    
    /// 检测是否可以从AppStore促销点击购买处理
    func applePayServiceShouldAddStorePayment() -> Bool
    
    /// 购买成功
    func applePayServiceSuccess(receipt: String, orderId: String?)
    
    /// 恢复购买
    func applePayServiceRestore(receipt: String)
    
    /// 支付失败
    func applePayServiceFail(type: ApplePayManager.ResultFailType, message: String)
    
    /// 交易挂起（Ask to Buy 等），通知上层暂停超时
    func applePayServicePending()
}


/// 根据系统版本选择使用的内购实现
@MainActor
enum ApplePayServiceFactory {
    
    static func makeService() -> ApplePayService {
        /// iOS 15 及以上统一使用 StoreKit 2（StoreKit 1 老代码仅支持到 iOS 18，已废弃）
        return ApplyPaymentNew()
    }
}
