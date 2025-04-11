import Flutter
import FinvuSDK
import UIKit

// This extension of Error is required to do use FlutterError in any Swift code.
extension FlutterError: Error {}

public class FinvuFlutterSdkInternalPlugin: NSObject, FlutterPlugin, NativeFinvuManagerInternal {
    
    let formatter = ISO8601DateFormatter();
    
    public override init() {
        super.init()
        formatter.formatOptions =  [.withInternetDateTime, .withFractionalSeconds]
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let messenger : FlutterBinaryMessenger = registrar.messenger()
        let api : NativeFinvuManagerInternal & NSObjectProtocol = FinvuFlutterSdkInternalPlugin.init()
        NativeFinvuManagerInternalSetup.setUp(binaryMessenger: messenger, api: api);
    }
    
    func loginWithUsernameAndPasscode(username: String, passcode: String, totp: String?, deviceId: String?, completion: @escaping (Result<NativeLoginResponse, any Error>) -> Void) {
        FinvuManager.shared.loginWith(username: username, passcode: passcode, totp: totp, deviceId: deviceId) { response, error in
            if (error != nil) {
                completion(.failure(FlutterError(code: "\(error!.code)", message: error?.localizedDescription, details: nil)))
            } else {
                completion(.success((NativeLoginResponse(deviceBindingValid: response?.deviceBindingValid))))
            }
        }
    }
    
    func deviceBinding(otpLessToken: String, deviceId: String, osType: String, osVersion: String, appId: String, appVersion: String, simSerialNumber: String?, completion: @escaping (Result<NativeDeviceBindingResponse, any Error>) -> Void) {
        
        FinvuManager.shared.deviceBinding(otpLessToken: otpLessToken, deviceId: deviceId, osType: osType, osVersion: osVersion, appId: appId, appVersion: appVersion, simSerialNumber: simSerialNumber) { response, error in
            if (error != nil) {
                completion(.failure(FlutterError(code: "\(error!.code)", message: error?.localizedDescription, details: nil)))
            } else {
                completion(.success((NativeDeviceBindingResponse(secret: response?.secret))))
            }
        }
    }
    func initiateForgotPasscodeRequest(username: String, mobileNumber: String, completion: @escaping (Result<Void, Error>) -> Void) {
        FinvuManager.shared.initiateForgotPasscodeRequest(username: username, mobileNumber: mobileNumber) { error in
            if (error != nil) {
                completion(.failure(FlutterError(code: "\(error!.code)", message: error?.localizedDescription, details: nil)))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func verifyForgotPasscodeOTP(username: String, mobileNumber: String, otp: String, newPasscode: String, completion: @escaping (Result<Void, Error>) -> Void) {
        FinvuManager.shared.verifyForgotPasscodeOTP(username: username, mobileNumber: mobileNumber, otp: otp, newPasscode: newPasscode) { error in
            if (error != nil) {
                completion(.failure(FlutterError(code: "\(error!.code)", message: error?.localizedDescription, details: nil)))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func initiateForgotHandleRequest(mobileNumber: String, completion: @escaping (Result<Void, Error>) -> Void) {
        FinvuManager.shared.initiateForgotHandleRequest(mobileNumber: mobileNumber) { error in
            if (error != nil) {
                completion(.failure(FlutterError(code: "\(error!.code)", message: error?.localizedDescription, details: nil)))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func verifyForgotHandleOTP(otp: String, completion: @escaping (Result<NativeForgotHandleInternal, Error>) -> Void) {
        FinvuManager.shared.verifyForgotHandleOTP(otp: otp) { response, error in
            if (error != nil) {
                completion(.failure(FlutterError(code: "\(error!.code)", message: error?.localizedDescription, details: nil)))
            } else {
                completion(.success(NativeForgotHandleInternal(userIds: response!.userIds)))
            }
        }
    }
    
    func register(username: String, mobileNumber: String, passcode: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        FinvuManager.shared.registerWith(username: username, mobileNumber: mobileNumber, passcode: passcode) { error in
            if (error != nil) {
                completion(.failure(FlutterError(code: "\(error!.code)", message: error?.localizedDescription, details: nil)))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func fetchUserInfo(completion: @escaping (Result<NativeUserInfoInternal, any Error>) -> Void) {
        FinvuManager.shared.fetchUserInfo { userInfo, error in
            if (error != nil) {
                completion(.failure(FlutterError(code: "\(error!.code)", message: error?.localizedDescription, details: nil)))
            } else {
                completion(.success(NativeUserInfoInternal(userId: userInfo!.userId, mobileNumber: userInfo!.mobileNumber, emailId: userInfo!.emailId)))
            }
        }
    }
    
    func initiateAccountDataRequest(from: String, to: String, consentId: String, publicKeyExpiry: String, completion: @escaping (Result<NativeAccountDataInternal, any Error>) -> Void) {
        FinvuManager.shared.initiateAccountDataRequest(from: from, to: to, consentId: consentId, publicKeyExpiry: publicKeyExpiry) { response, error in
            if (error != nil) {
                completion(.failure(FlutterError(code: "\(error!.code)", message: error?.localizedDescription, details: nil)))
            } else {
                completion(.success(NativeAccountDataInternal(consentId: response?.consentId, timestamp: (response?.timestamp != nil) ? self.formatter.string(from: (response?.timestamp!)!) : nil, sessionId: response?.sessionId, transactionId: response?.transactionId)))
            }
        }
    }

    func fetchAccountData(sessionId: String, consentId: String, completion: @escaping (Result<NativeAccountDataFetchInternal, any Error>) -> Void) {
        FinvuManager.shared.fetchAccountData(sessionId: sessionId, consentId: consentId) { response, error in
            if (error != nil) {
                completion(.failure(FlutterError(code: "\(error!.code)", message: error?.localizedDescription, details: nil)))
            } else {
                let dataList = response!.decryptedInfo
                    .map { data in
                        NativeFIDecryptedDataInfoInternal(
                            linkReferenceNumber: data.linkReferenceNumber,
                            accountReferenceNumber: data.accountReferenceNumber,
                            maskedAccountNumber: data.maskedAccountNumber,
                            fiType: data.fiType,
                            accountType: data.accountType,
                            decryptedData: data.decryptedData
                        )
                    }
                completion(.success(NativeAccountDataFetchInternal(fipId: response!.fipId, decryptedInfo: dataList)))
            }
        }
    }

    func getConsentHistory(consentId: String, completion: @escaping (Result<NativeConsentHistoryResponseInternal, any Error>) -> Void) {
        FinvuManager.shared.getConsentHistory(consentId: consentId) { response, error in
            if (error != nil) {
                completion(.failure(FlutterError(code: "\(error!.code)", message: error?.localizedDescription, details: nil)))
            } else {
                let consentHistoryResponse = NativeConsentHistoryResponseInternal(
                    consentHistory: response?.consentHistory.map { history in
                        NativeConsentHistoryInternal(
                            consentId: history.consentId,
                            consentTimestamp: (history.consentTimestamp != nil) ? self.formatter.string(from: history.consentTimestamp!) : nil
                        )
                    }
                )
                completion(.success(NativeConsentHistoryResponseInternal(consentHistory:  consentHistoryResponse.consentHistory)))
            }
        }
    }

    func unlinkAccount(account: NativeLinkedAccountDetailsInfoInternal, completion: @escaping (Result<Void, Error>) -> Void) {
        
        let consentIdList = account.consentIdList?
            .filter({ consentId in
                consentId != nil
            }).map({ consentId in
                consentId!
            })
        
        let accountInfo = LinkedAccountDetailsInfo(
            userId: account.userId,
            fipId: account.fipId,
            fipName: account.fipName,
            maskedAccountNumber: account.maskedAccountNumber,
            accountReferenceNumber: account.accountReferenceNumber,
            linkReferenceNumber: account.linkReferenceNumber,
            consentIdList: consentIdList,
            fiType: account.fiType,
            accountType: account.accountType,
            linkedAccountUpdateTimestamp: (account.linkedAccountUpdateTimestamp != nil) ? formatter.date(from: account.linkedAccountUpdateTimestamp!) : nil,
            authenticatorType: account.authenticatorType
        )
        
        FinvuManager.shared.unlinkAccount(accountInfo: accountInfo) { error in
            if (error != nil) {
                completion(.failure(FlutterError(code: "\(error!.code)", message: error?.localizedDescription, details: nil)))
                return
            }
            
            completion(.success(()))
        }
    }
    
    func getUserConsents(completion: @escaping (Result<NativeUserConsentResponseInternal, Error>) -> Void) {
        FinvuManager.shared.getUserConsents { response, error in
            if (error != nil) {
                completion(.failure(FlutterError(code: "\(error!.code)", message: error?.localizedDescription, details: nil)))
                return
            }
            
            let consents = response!.userConsents.map({ consent in
                NativeUserConsentInfoInternal(consentIntentId: consent.consentIntentId,
                                      consentIntentEntityId: consent.consentIntentEntityId,
                                      consentIntentEntityName: consent.consentIntentEntityName,
                                      consentIdList: consent.consentIdList,
                                      consentIntentUpdateTimestamp: self.formatter.string(from: consent.consentIntentUpdateTimestamp),
                                      consentPurposeText: consent.consentPurposeText,
                                      status: consent.status)
            })
            
            completion(.success(NativeUserConsentResponseInternal(userConsents: consents)))
        }
    }

    func requestSelfConsent(request: NativeSelfConsentRequestInternal, completion: @escaping (Result<Void, Error>) -> Void) {
        let accounts = request.linkedAccounts
            .compactMap { linkedAccount -> LinkedAccountDetailsInfo? in
                guard let linkedAccount = linkedAccount else {
                    return nil
                }

                let consentIdList = linkedAccount.consentIdList?.compactMap { $0 } ?? []
                let linkedAccountUpdateTimestamp = linkedAccount.linkedAccountUpdateTimestamp.flatMap { formatter.date(from: $0) } ?? Date()

                return LinkedAccountDetailsInfo(
                    userId: linkedAccount.userId,
                    fipId: linkedAccount.fipId,
                    fipName: linkedAccount.fipName,
                    maskedAccountNumber: linkedAccount.maskedAccountNumber,
                    accountReferenceNumber: linkedAccount.accountReferenceNumber,
                    linkReferenceNumber: linkedAccount.linkReferenceNumber,
                    consentIdList: consentIdList,
                    fiType: linkedAccount.fiType,
                    accountType: linkedAccount.accountType,
                    linkedAccountUpdateTimestamp: linkedAccountUpdateTimestamp,
                    authenticatorType: linkedAccount.authenticatorType
                )
            }
        
        FinvuManager.shared.requestSelfConsent(
            createTime: formatter.date(from: request.createTime)!,
            startTime: formatter.date(from: request.startTime)!,
            expireTime: formatter.date(from: request.expireTime)!,
            linkedAccounts: accounts,
            consentTypes: request.consentTypes.compactMap { $0 },
            consentFiTypes: request.consentFiTypes.compactMap { $0 },
            mode: request.mode,
            fetchType: request.fetchType,
            frequency: ConsentDataFrequency(unit: request.frequency.unit, value: request.frequency.value),
            dataLife: ConsentDataLifePeriod(unit: request.dataLife.unit, value: request.dataLife.value),
            purposeText: request.purposeText,
            purposeType: request.purposeType
        ) { _, error in
            if (error != nil) {
                completion(.failure(FlutterError(code: "\(error!.code)", message: error?.localizedDescription, details: nil)))
                return
            }

            completion(.success(()))
        }
    }
    
    func getUserConsentDetails(consent: NativeUserConsentInfoInternal, completion: @escaping (Result<NativeConsentInfoDetailsInternal, Error>) -> Void) {
        let consentInfo = UserConsentInfo(consentIntentId: consent.consentIntentId,
                                          consentIntentEntityId: consent.consentIntentEntityId,
                                          consentIntentEntityName: consent.consentIntentEntityName,
                                          consentIdList: consent.consentIdList
            .filter({ consentId in consentId != nil})
            .map({ consentId in consentId! }),
                                          consentIntentUpdateTimestamp: formatter.date(from: consent.consentIntentUpdateTimestamp)!,
                                          consentPurposeText: consent.consentPurposeText,
                                          status: consent.status)
        FinvuManager.shared.getConsentDetails(consentInfo: consentInfo) { response, error in
            if (error != nil) {
                completion(.failure(FlutterError(code: "\(error!.code)", message: error?.localizedDescription, details: nil)))
                return
            }
            
            let consentDetail = self.getNativeConsentInfoDetails(userConsentDetails: response!)
            completion(.success(consentDetail))
        }
    }
    
    func getUserConsentDetailsForId(consentId: String, completion: @escaping (Result<NativeConsentInfoDetailsInternal, Error>) -> Void) {
        FinvuManager.shared.getConsentDetailsForId(consentId: consentId) { response, error in
            if (error != nil) {
                completion(.failure(FlutterError(code: "\(error!.code)", message: error?.localizedDescription, details: nil)))
                return
            }
            
            let consentDetail = self.getNativeConsentInfoDetails(userConsentDetails: response!)
            completion(.success(consentDetail))
        }
    }
    
    func fetchOfflineMessages(completion: @escaping (Result<NativeFetchOfflineMessageResponseInternal, Error>) -> Void) {
        FinvuManager.shared.fetchOfflineMessages { response, error in
            if (error != nil) {
                completion(.failure(FlutterError(code: "\(error!.code)", message: error?.localizedDescription, details: nil)))
                return
            }
            let offlineMessages = response!.messages?.map({ offlineMessage in
                NativeOfflineMessageInfoInternal(
                    userId: offlineMessage.userId,
                    messageId: offlineMessage.messageId,
                    messageAcked: offlineMessage.messageAcked,
                    messageOriginator: offlineMessage.messageOriginator,
                    messageOriginatorName: offlineMessage.messageOriginatorName,
                    messageText: offlineMessage.messageText,
                    messageTimestamp: offlineMessage.messageTimestamp,
                    messageType: offlineMessage.messageType,
                    requestConsentId: offlineMessage.requestConsentId,
                    requestSessionId: offlineMessage.requestSessionId
                )
                
            })
            completion(.success(NativeFetchOfflineMessageResponseInternal(offlineMessageInfo: offlineMessages ?? [])))
        }
    }
    
    func closeFinvuAccount(password: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        FinvuManager.shared.closeFinvuAccount(password: password) { error in
            if (error != nil) {
                completion(.failure(FlutterError(code: "\(error!.code)", message: error?.localizedDescription, details: nil)))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func changePasscode(currentPasscode: String, newPasscode: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        FinvuManager.shared.changePasscode(currentPasscode: currentPasscode,newPasscode: newPasscode) { error in
            if (error != nil) {
                completion(.failure(FlutterError(code: "\(error!.code)", message: error?.localizedDescription, details: nil)))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func getUserConsentReport(completion: @escaping (Result<NativeConsentReportInternal, any Error>) -> Void) {
        FinvuManager.shared.getUserConsentReport { consentReport, error in
            if (error != nil) {
                completion(.failure(FlutterError(code: "\(error!.code)", message: error?.localizedDescription, details: nil)))
            } else {
                completion(.success(NativeConsentReportInternal(report: consentReport!.report)))
            }
        }
    }
    
    func fetchPendingConsentRequests(completion: @escaping (Result<NativePendingConsentRequestsResponseInternal, Error>) -> Void) {
        FinvuManager.shared.fetchPendingConsentRequests { response, error in
            if (error != nil) {
                completion(.failure(FlutterError(code: "\(error!.code)", message: error?.localizedDescription, details: nil)))
                return
            }
            
            let pendingConsentRequests = response?.details.map({ consentRequest in
                NativeConsentRequestDetailInfoInternal(
                    consentHandleId: consentRequest.consentHandle,
                    financialInformationUser: NativeFinancialInformationEntityInternal(
                        id: consentRequest.financialInformationUser.id,
                        name: consentRequest.financialInformationUser.name
                    ),
                    consentPurposeInfo: NativeConsentPurposeInfoInternal(
                        code: consentRequest.consentPurposeInfo.code,
                        text: consentRequest.consentPurposeInfo.text
                    ),
                    consentDisplayDescriptions: consentRequest.consentDisplayDescriptions,
                    dataDateTimeRange: NativeDateTimeRangeInternal(
                        from: self.formatter.string(from: consentRequest.dataDateTimeRange.from),
                        to: self.formatter.string(from: consentRequest.dataDateTimeRange.to)
                    ),
                    consentDateTimeRange: NativeDateTimeRangeInternal(
                        from: self.formatter.string(from: consentRequest.consentDateTimeRange.from),
                        to: self.formatter.string(from: consentRequest.consentDateTimeRange.to)
                    ),
                    consentDataFrequency: NativeConsentDataFrequencyInternal(
                        unit: consentRequest.consentDataFrequency.unit,
                        value: consentRequest.consentDataFrequency.value
                    ),
                    consentDataLifePeriod: NativeConsentDataLifePeriodInternal(
                        unit: consentRequest.consentDataLifePeriod.unit,
                        value: consentRequest.consentDataLifePeriod.value
                    ),
                    fiTypes: consentRequest.fiTypes?.compactMap { $0 },
                    statusLastUpdateTimestamp: self.getDateOrNil(date: consentRequest.statusLastUpdateTimestamp)
                )
            })
            
            completion(.success(NativePendingConsentRequestsResponseInternal(details: pendingConsentRequests ?? [])))
        }
    }
    
    private func getNativeConsentInfoDetails(userConsentDetails: UserConsentDetails) -> NativeConsentInfoDetailsInternal {
        let financialInformationProvider = (userConsentDetails.financialInformationProvider != nil) ? NativeFinancialInformationEntityInternal(
            id: userConsentDetails.financialInformationProvider!.id,
            name: userConsentDetails.financialInformationProvider!.name
        ) : nil
        
        let financialInformationUser = (userConsentDetails.financialInformationUser != nil) ? NativeFinancialInformationEntityInternal(
            id: userConsentDetails.financialInformationUser!.id,
            name: userConsentDetails.financialInformationUser!.name
        ) : nil
        
        return NativeConsentInfoDetailsInternal(
            consentHandle: userConsentDetails.consentHandle,
            consentId: userConsentDetails.consentId,
            consentStatus: userConsentDetails.consentStatus,
            financialInformationProvider: financialInformationProvider,
            financialInformationUser: financialInformationUser,
            consentPurpose: NativeConsentPurposeInfoInternal(
                code: userConsentDetails.consentPurposeInfo.code,
                text: userConsentDetails.consentPurposeInfo.text
            ),
            consentDisplayDescriptions: userConsentDetails.consentDisplayDescriptions,
            dataDateTimeRange: NativeDateTimeRangeInternal(
                from: self.formatter.string(from: userConsentDetails.dataDateTimeRange.from),
                to: self.formatter.string(from: userConsentDetails.dataDateTimeRange.to)
            ),
            consentDateTimeRange: NativeDateTimeRangeInternal(
                from: self.formatter.string(from: userConsentDetails.consentDateTimeRange.from),
                to: self.formatter.string(from: userConsentDetails.consentDateTimeRange.to)
            ),
            consentDataLifePeriod: NativeConsentDataLifePeriodInternal(
                unit: userConsentDetails.consentDataLifePeriod.unit,
                value: userConsentDetails.consentDataLifePeriod.value
            ),
            consentDataFrequency: NativeConsentDataFrequencyInternal(
                unit: userConsentDetails.consentDataFrequency.unit,
                value: userConsentDetails.consentDataFrequency.value
            ),
            accounts: userConsentDetails.accounts.map({ account in
                NativeConsentAccountDetailsInternal(
                    fiType: account.fiType,
                    fipId: account.fipId,
                    accountType: account.accountType,
                    maskedAccountNumber: account.maskedAccountNumber,
                    linkReferenceNumber: account.linkReferenceNumber
                )
            }),
            fiTypes: userConsentDetails.fiTypes,
            accountAggregator: NativeAccountAggregatorInternal(id: userConsentDetails.accountAggregator.id),
            statusLastUpdateTimestamp: self.getDateOrNil(date: userConsentDetails.statusLastUpdateTimestamp)
        )
    }
    
    func getDateOrNil(date: Date?) -> String? {
        return if (date != nil) {
            self.formatter.string(from: date!)
        } else {
            nil
        }
    }

}
