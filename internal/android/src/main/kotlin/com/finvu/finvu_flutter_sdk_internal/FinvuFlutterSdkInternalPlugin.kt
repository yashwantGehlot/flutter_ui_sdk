package com.finvu.finvu_flutter_sdk_internal

import NativeConsentAccountDetailsInternal
import NativeConsentDataFrequencyInternal
import NativeConsentDataLifePeriodInternal
import NativeConsentHistoryInternal
import NativeConsentHistoryResponseInternal
import NativeConsentInfoDetailsInternal
import NativeConsentPurposeInfoInternal
import NativeConsentReportInternal
import NativeConsentRequestDetailInfoInternal
import NativeDateTimeRangeInternal
import NativeFetchOfflineMessageResponseInternal
import NativeFinancialInformationEntityInternal
import NativeFinvuErrorInternal
import NativeFinvuManagerInternal
import NativeForgotHandleInternal
import NativeLinkedAccountDetailsInfoInternal
import NativeSelfConsentRequestInternal
import NativeOfflineMessageInfoInternal
import NativePendingConsentRequestsResponseInternal
import NativeUserConsentInfoInternal
import NativeUserConsentResponseInternal
import NativeUserInfoInternal
import NativeAccountAggregatorInternal
import NativeAccountDataInternal
import NativeAccountDataFetchInternal
import NativeDeviceBindingResponse
import NativeFIDecryptedDataInfoInternal
import NativeLoginResponse
import com.finvu.android.FinvuManagerInternal
import com.finvu.android.publicInterface.ConsentInfoDetails
import com.finvu.android.publicInterface.FinvuException
import com.finvu.android.publicInterface.LinkedAccountDetails
import com.finvu.android.publicInterface.UserConsentInfo
import com.finvu.android.publicInterface.ConsentDataLifePeriod
import com.finvu.android.publicInterface.ConsentDataFrequency
import com.finvu.android.publicInterface.AccountDataFetchResponse
import com.finvu.android.publicInterface.FIDecryptedDataInfo
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodChannel
import java.text.SimpleDateFormat
import java.util.Locale
import java.util.TimeZone

/** FinvuFlutterSdkInternalPlugin */
@Suppress("LABEL_NAME_CLASH")
class FinvuFlutterSdkInternalPlugin: FlutterPlugin, NativeFinvuManagerInternal {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  private val dateFormatter = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSXXX", Locale.getDefault())

  init {
    dateFormatter.timeZone = TimeZone.getDefault()
  }

  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    NativeFinvuManagerInternal.setUp(binding.binaryMessenger, this)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    NativeFinvuManagerInternal.setUp(binding.binaryMessenger, null)
  }

  override fun closeFinvuAccount(
    password: String,
    callback: (Result<Unit>) -> Unit
  ) {
    FinvuManagerInternal.shared.closeFinvuAccount(password = password) {
      if (it.isFailure) {
        val error = it.exceptionOrNull() as FinvuException
        callback(
          Result.failure(
            NativeFinvuErrorInternal(
              code = error.code.toString(),
              message = error.message
            )
          )
        )
        return@closeFinvuAccount
      }

      callback(Result.success(Unit))
    }
  }

  override fun changePasscode(
    currentPasscode: String,
    newPasscode: String,
    callback: (Result<Unit>) -> Unit
  ) {
    FinvuManagerInternal.shared.changePasscode(currentPasscode = currentPasscode, newPasscode = newPasscode) {
      if (it.isFailure) {
        val error = it.exceptionOrNull() as FinvuException
        callback(Result.failure(NativeFinvuErrorInternal(code = error.code.toString(), message = error.message)))
        return@changePasscode
      }

      callback(Result.success(Unit))
    }
  }

  override fun fetchAccountData(
    sessionId: String,
    consentId: String,
    callback: (Result<NativeAccountDataFetchInternal>) -> Unit
  ) {
    FinvuManagerInternal.shared.fetchAccountData(consentId, sessionId) { result ->
      if (result.isFailure) {
        val error = result.exceptionOrNull() as FinvuException
        callback(Result.failure(NativeFinvuErrorInternal(code = error.code.toString(), message = error.message)))
        return@fetchAccountData
      }

      val response = result.getOrThrow()
      val dataList = response.decryptedInfo
        .map {
          NativeFIDecryptedDataInfoInternal(
            linkReferenceNumber = it.linkReferenceNumber,
            accountReferenceNumber = it.accountReferenceNumber,
            maskedAccountNumber = it.maskedAccountNumber,
            fiType = it.fiType,
            accountType = it.accountType,
            decryptedData = it.decryptedData
          )
        }
      val responseData = NativeAccountDataFetchInternal(fipId = response.fipId, decryptedInfo = dataList)
      callback(Result.success(responseData))
    }
  }

  override fun getConsentHistory(
    consentId: String,
    callback: (Result<NativeConsentHistoryResponseInternal>) -> Unit
  ) {
    FinvuManagerInternal.shared.getConsentHistory(consentId) { result ->
      if (result.isFailure) {
        val error = result.exceptionOrNull() as FinvuException
        callback(Result.failure(NativeFinvuErrorInternal(code = error.code.toString(), message = error.message)))
        return@getConsentHistory
      }

      val response = result.getOrThrow()
      val consentHistoryResponse = NativeConsentHistoryResponseInternal(consentHistory = response.consentHistory.map { NativeConsentHistoryInternal(it.consentId,it.consentTimestamp.let { date -> dateFormatter.format(date) })})
      callback(Result.success(consentHistoryResponse))
    }
  }

  override fun initiateAccountDataRequest(
    from: String,
    to: String,
    consentId: String,
    publicKeyExpiry: String,
    callback: (Result<NativeAccountDataInternal>) -> Unit
  ) {
    FinvuManagerInternal.shared.initiateAccountDataRequest(from = from, to = to, consentId = consentId, publicKeyExpiry = publicKeyExpiry) {
      if (it.isFailure) {
        val error = it.exceptionOrNull() as FinvuException
        callback(Result.failure(NativeFinvuErrorInternal(code = error.code.toString(), message = error.message)))
        return@initiateAccountDataRequest
      }

      val response = it.getOrThrow()
      val dataRequestResponse = NativeAccountDataInternal(
        consentId = response.consentId,
        timestamp = dateFormatter.format(response.timestamp!!),
        sessionId = response.sessionId,
        transactionId = response.transactionId
      )
      callback(Result.success(dataRequestResponse))
    }
  }


  override fun getUserConsentReport(callback: (Result<NativeConsentReportInternal>) -> Unit) {
    FinvuManagerInternal.shared.getUserConsentReport { result ->
      if (result.isFailure) {
        val error = result.exceptionOrNull() as FinvuException
        callback(Result.failure(NativeFinvuErrorInternal(code = error.code.toString(), message = error.message)))
        return@getUserConsentReport
      }

      val response = result.getOrThrow()
      callback(Result.success(NativeConsentReportInternal(response.report)))
    }
  }

  override fun loginWithUsernameAndPasscode(username: String,
                                            passcode: String,
                                            totp: String?,
                                            deviceId: String?,
                                            callback: (Result<NativeLoginResponse>) -> Unit) {
    FinvuManagerInternal.shared.loginWithUsernameAndPasscode(username = username, passcode = passcode, totp = totp, deviceId = deviceId) {
      if (it.isFailure) {
        val error = it.exceptionOrNull() as FinvuException
        callback(Result.failure(NativeFinvuErrorInternal(code = error.code.toString(), message = error.message)))
        return@loginWithUsernameAndPasscode
      }

      callback(Result.success(NativeLoginResponse(it.getOrNull()?.deviceBindingValid)))
    }
  }

  override fun deviceBinding(
    otpLessToken: String,
    deviceId: String,
    osType: String,
    osVersion: String,
    appId: String,
    appVersion: String,
    simSerialNumber: String?,
    callback: (Result<NativeDeviceBindingResponse>) -> Unit
  ) {
    FinvuManagerInternal.shared.deviceBinding(
      otpLessToken = otpLessToken,
      deviceId = deviceId,
      osType = osType,
      osVersion = osVersion,
      appId = appId,
      appVersion = appVersion,
      simSerialNumber = simSerialNumber
    ) {
      if (it.isFailure) {
        val error = it.exceptionOrNull() as FinvuException
        callback(
          Result.failure(
            NativeFinvuErrorInternal(
              code = error.code.toString(),
              message = error.message
            )
          )
        )
        return@deviceBinding
      }

      callback(Result.success(NativeDeviceBindingResponse(it.getOrNull()?.secret)))
    }
  }

  override fun initiateForgotPasscodeRequest(
    username: String,
    mobileNumber: String,
    callback: (Result<Unit>) -> Unit
  ) {
    FinvuManagerInternal.shared.initiateForgotPasscodeRequest(username = username, mobileNumber = mobileNumber) {
      if (it.isFailure) {
        val error = it.exceptionOrNull() as FinvuException
        callback(Result.failure(NativeFinvuErrorInternal(code = error.code.toString(), message = error.message)))
        return@initiateForgotPasscodeRequest
      }

      callback(Result.success(Unit))
    }
  }

  override fun verifyForgotPasscodeOTP(
    username: String,
    mobileNumber: String,
    otp: String,
    newPasscode: String,
    callback: (Result<Unit>) -> Unit
  ) {
    FinvuManagerInternal.shared.verifyForgotPasscodeOTP(
      username = username,
      mobileNumber = mobileNumber,
      otp = otp,
      newPassword = newPasscode) {
      if (it.isFailure) {
        val error = it.exceptionOrNull() as FinvuException
        callback(Result.failure(NativeFinvuErrorInternal(code = error.code.toString(), message = error.message)))
        return@verifyForgotPasscodeOTP
      }

      callback(Result.success(Unit))
    }
  }

  override fun initiateForgotHandleRequest(mobileNumber: String, callback: (Result<Unit>) -> Unit) {
    FinvuManagerInternal.shared.initiateForgotHandleRequest(mobileNumber) {
      if (it.isFailure) {
        val error = it.exceptionOrNull() as FinvuException
        callback(Result.failure(NativeFinvuErrorInternal(code = error.code.toString(), message = error.message)))
        return@initiateForgotHandleRequest
      }

      callback(Result.success(Unit))
    }
  }

  override fun verifyForgotHandleOTP(
    otp: String,
    callback: (Result<NativeForgotHandleInternal>) -> Unit
  ) {
    FinvuManagerInternal.shared.verifyForgotHandleOTP(otp = otp) {
      if (it.isFailure) {
        val error = it.exceptionOrNull() as FinvuException
        callback(Result.failure(NativeFinvuErrorInternal(code = error.code.toString(), message = error.message)))
        return@verifyForgotHandleOTP
      }

      val response = it.getOrThrow()
      callback(Result.success(NativeForgotHandleInternal(response.userIds)))
    }
  }

  override fun register(
    username: String,
    mobileNumber: String,
    passcode: String,
    callback: (Result<Unit>) -> Unit
  ) {
    FinvuManagerInternal.shared.register(username = username, mobileNumber = mobileNumber, password = passcode) {
      if (it.isFailure) {
        val error = it.exceptionOrNull() as FinvuException
        callback(Result.failure(NativeFinvuErrorInternal(code = error.code.toString(), message = error.message)))
        return@register
      }

      callback(Result.success(Unit))
    }
  }

  override fun fetchUserInfo(callback: (Result<NativeUserInfoInternal>) -> Unit) {
    FinvuManagerInternal.shared.fetchUserInfo {
      if (it.isFailure) {
        val error = it.exceptionOrNull() as FinvuException
        callback(Result.failure(NativeFinvuErrorInternal(code = error.code.toString(), message = error.message)))
        return@fetchUserInfo
      }

      val response = it.getOrThrow()
      val userInfo = NativeUserInfoInternal(
        userId = response.userId,
        mobileNumber = response.mobileNumber,
        emailId = response.emailId
      )

      callback(Result.success(userInfo))
    }
  }

  override fun unlinkAccount(
    account: NativeLinkedAccountDetailsInfoInternal,
    callback: (Result<Unit>) -> Unit
  ) {
    val finvuAccount = LinkedAccountDetails(
      userId = account.userId,
      fipId = account.fipId,
      fipName = account.fipName,
      maskedAccountNumber = account.maskedAccountNumber,
      accountReferenceNumber = account.accountReferenceNumber,
      linkReferenceNumber = account.linkReferenceNumber,
      consentIdList = account.consentIdList?.filterNotNull(),
      fiType = account.fiType,
      accountType = account.accountType,
      linkedAccountUpdateTimestamp = account.linkedAccountUpdateTimestamp?.let { dateFormatter.parse(it) },
      authenticatorType = account.authenticatorType
    )

    FinvuManagerInternal.shared.unlinkAccount(finvuAccount) { result ->
      if (result.isFailure) {
        val error = result.exceptionOrNull() as FinvuException
        callback(Result.failure(NativeFinvuErrorInternal(code = error.code.toString(), message = error.message)))
        return@unlinkAccount
      }

      callback(Result.success(Unit))
    }
  }

  override fun getUserConsents(callback: (Result<NativeUserConsentResponseInternal>) -> Unit) {
    FinvuManagerInternal.shared.getUserConsents { result ->
      if (result.isFailure) {
        val error = result.exceptionOrNull() as FinvuException
        callback(Result.failure(NativeFinvuErrorInternal(code = error.code.toString(), message = error.message)))
        return@getUserConsents
      }

      val consents = result.getOrThrow().userConsents.map {
        NativeUserConsentInfoInternal(
          consentIntentId = it.consentIntentId,
          consentIdList = it.consentIdList,
          consentIntentEntityId = it.consentIntentEntityId,
          consentIntentEntityName = it.consentIntentEntityName,
          consentPurposeText = it.consentPurposeText,
          consentIntentUpdateTimestamp = dateFormatter.format(it.consentIntentUpdateTimestamp),
          status = it.status
        )
      }
      callback(Result.success(NativeUserConsentResponseInternal(consents)))
    }
  }

  override fun requestSelfConsent(
    request: NativeSelfConsentRequestInternal,
    callback: (Result<Unit>) -> Unit
  ) {

    val accounts = request.linkedAccounts
      .filterNotNull()
      .map {
        LinkedAccountDetails(
          userId = it.userId,
          fipId = it.fipId,
          fipName = it.fipName,
          maskedAccountNumber = it.maskedAccountNumber,
          accountReferenceNumber = it.accountReferenceNumber,
          linkReferenceNumber = it.linkReferenceNumber,
          consentIdList = it.consentIdList?.filterNotNull(),
          fiType = it.fiType,
          accountType = it.accountType,
          linkedAccountUpdateTimestamp = it.linkedAccountUpdateTimestamp?.let { dateFormatter.parse(it) },
          authenticatorType = it.authenticatorType
        )
      }
    FinvuManagerInternal.shared.requestSelfConsent(
      createTime = dateFormatter.parse(request.createTime),
      startTime = dateFormatter.parse(request.startTime),
      expireTime = dateFormatter.parse(request.expireTime),
      linkedAccounts = accounts,
      consentTypes = request.consentTypes.filterNotNull(),
      consentFiTypes = request.consentFiTypes.filterNotNull(),
      mode = request.mode,
      fetchType = request.fetchType,
      frequency = ConsentDataFrequency(unit = request.frequency.unit, value = request.frequency.value),
      dataLife = ConsentDataLifePeriod(unit = request.dataLife.unit, value = request.dataLife.value),
      purposeText = request.purposeText,
      purposeType = request.purposeType,
    ) { result ->
      if (result.isFailure) {
        val error = result.exceptionOrNull() as FinvuException
        callback(Result.failure(NativeFinvuErrorInternal(code = error.code.toString(), message = error.message)))
        return@requestSelfConsent
      }

      callback(Result.success(Unit))
    }
  }

  override fun getUserConsentDetails(
    consent: NativeUserConsentInfoInternal,
    callback: (Result<NativeConsentInfoDetailsInternal>) -> Unit
  ) {
    val consentInfo = UserConsentInfo(
      consentIntentId = consent.consentIntentId,
      consentIdList = consent.consentIdList.filterNotNull(),
      consentIntentEntityId = consent.consentIntentEntityId,
      consentIntentEntityName = consent.consentIntentEntityName,
      consentPurposeText = consent.consentPurposeText,
      consentIntentUpdateTimestamp = dateFormatter.parse(consent.consentIntentUpdateTimestamp)!!,
      status = consent.status
    )

    FinvuManagerInternal.shared.getUserConsentDetails(consentInfo) { result ->
      handleGetUserConsentDetailsResult(result, callback)
    }
  }

  override fun fetchOfflineMessages(callback: (Result<NativeFetchOfflineMessageResponseInternal>) -> Unit) {
    FinvuManagerInternal.shared.fetchOfflineMessages { result ->
      if (result.isFailure) {
        val error = result.exceptionOrNull() as FinvuException
        callback(Result.failure(NativeFinvuErrorInternal(code = error.code.toString(), message = error.message)))
        return@fetchOfflineMessages
      }

      val response = result.getOrThrow()
      val accounts = response.offlineMessages?.map {
        NativeOfflineMessageInfoInternal(
          userId = it.userId,
          messageId = it.messageId,
          messageAcked = it.messageAcked,
          messageOriginator = it.messageOriginator,
          messageOriginatorName = it.messageOriginatorName,
          messageText = it.messageText,
          messageTimestamp = it.messageTimestamp.let { date -> dateFormatter.format(date!!) } ,
          messageType = it.messageType,
          requestConsentId = it.requestConsentId,
          requestSessionId = it.requestSessionId
        )
      }?: listOf()
      callback(Result.success(NativeFetchOfflineMessageResponseInternal(accounts)))
    }
  }

  override fun fetchPendingConsentRequests(callback: (Result<NativePendingConsentRequestsResponseInternal>) -> Unit) {
    FinvuManagerInternal.shared.fetchPendingConsentRequests { result ->
      if (result.isFailure) {
        val error = result.exceptionOrNull() as FinvuException
        callback(Result.failure(NativeFinvuErrorInternal(code = error.code.toString(), message = error.message)))
        return@fetchPendingConsentRequests
      }

      val response = result.getOrThrow()
      val consentRequests = response.details?.map {
        val statusLastUpdateTimestamp = it.statusLastUpdateTimestamp?.let {
          dateFormatter.format(it)
        } ?: ""

        NativeConsentRequestDetailInfoInternal(
          consentHandleId = it.consentHandle,
          statusLastUpdateTimestamp = statusLastUpdateTimestamp,
          financialInformationUser = NativeFinancialInformationEntityInternal(
            id = it.financialInformationUser.id,
            name = it.financialInformationUser.name
          ),
          consentPurposeInfo = NativeConsentPurposeInfoInternal(
            code = it.consentPurpose.code,
            text = it.consentPurpose.text
          ),
          consentDisplayDescriptions = it.consentDisplayDescriptions,
          dataDateTimeRange = NativeDateTimeRangeInternal(
            from = dateFormatter.format(it.dataDateTimeRange.from),
            to = dateFormatter.format(it.dataDateTimeRange.to)
          ),
          consentDateTimeRange = NativeDateTimeRangeInternal(
            from = dateFormatter.format(it.consentDateTimeRange.from),
            to = dateFormatter.format(it.consentDateTimeRange.to)
          ),
          consentDataFrequency = NativeConsentDataFrequencyInternal(
            unit = it.consentDataFrequency.unit,
            value = it.consentDataFrequency.value
          ),
          consentDataLifePeriod = NativeConsentDataLifePeriodInternal(
            unit = it.consentDataLife.unit,
            value = it.consentDataLife.value
          ),
          fiTypes = it.fiTypes
        )
      }

      callback(Result.success(NativePendingConsentRequestsResponseInternal(consentRequests.orEmpty())))
    }
  }

  override fun getUserConsentDetailsForId(
    consentId: String,
    callback: (Result<NativeConsentInfoDetailsInternal>) -> Unit
  ) {
    FinvuManagerInternal.shared.getUserConsentDetailsForId(consentId = consentId) { result ->
      handleGetUserConsentDetailsResult(result, callback)
    }
  }

  private fun handleGetUserConsentDetailsResult(
    result: Result<ConsentInfoDetails>,
    callback: (Result<NativeConsentInfoDetailsInternal>) -> Unit
  ) {
    if (result.isFailure) {
      val error = result.exceptionOrNull() as FinvuException
      callback(Result.failure(NativeFinvuErrorInternal(code = error.code.toString(), message = error.message)))
      return
    }

    val response = result.getOrThrow()

    val financialInformationUserInfo = response.financialInformationUser?.let {
      NativeFinancialInformationEntityInternal(id = it.id, name = it.name)
    }

    val financialInformationProviderInfo = response.financialInformationProvider?.let {
      NativeFinancialInformationEntityInternal(id = it.id, name = it.name)
    }

//    val statusLastUpdateTimestamp = if(response.statusLastUpdateTimestamp != "") dateFormatter.format(response.statusLastUpdateTimestamp) else ""
    val consentDetails = NativeConsentInfoDetailsInternal(
      consentId = response.consentId,
      consentHandle = response.consentHandle,
      consentStatus = response.consentStatus,
      consentPurpose = NativeConsentPurposeInfoInternal(
        code = response.consentPurpose.code,
        text = response.consentPurpose.text
      ),
      statusLastUpdateTimestamp = response.statusLastUpdateTimestamp ,
      consentDisplayDescriptions = response.consentDisplayDescriptions,
      dataDateTimeRange = NativeDateTimeRangeInternal(
        from = dateFormatter.format(response.dataDateTimeRange.from),
        to = dateFormatter.format(response.dataDateTimeRange.to)
      ),
      consentDateTimeRange = NativeDateTimeRangeInternal(
        from = dateFormatter.format(response.consentDateTimeRange.from),
        to = dateFormatter.format(response.consentDateTimeRange.to)
      ),
      consentDataFrequency = NativeConsentDataFrequencyInternal(
        unit = response.consentDataFrequency.unit,
        value = response.consentDataFrequency.value
      ),
      consentDataLifePeriod = NativeConsentDataLifePeriodInternal(
        unit = response.consentDataLife.unit,
        value = response.consentDataLife.value
      ),
      financialInformationProvider = financialInformationProviderInfo,
      financialInformationUser = financialInformationUserInfo,
      accounts = response.accounts.map {
        NativeConsentAccountDetailsInternal(
          fipId = it.fipId,
          maskedAccountNumber = it.maskedAccountNumber,
          accountReferenceNumber = it.accountReferenceNumber,
          linkReferenceNumber = it.linkReferenceNumber,
          fiType = it.fiType,
          accountType = it.accountType,
        )
      },
      fiTypes = response.fiTypes,
      accountAggregator = NativeAccountAggregatorInternal(id = response.accountAggregator.id)
    )

    callback(Result.success(consentDetails))
  }
}
