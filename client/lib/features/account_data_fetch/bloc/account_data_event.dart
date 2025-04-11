import 'package:equatable/equatable.dart';
import 'package:finvu_flutter_sdk/common/models/consent.dart';

sealed class AccountDataEvent extends Equatable {
  const AccountDataEvent();

  @override
  List<Object> get props => [];
}

final class AccountDataFetchRequestSubmitted extends AccountDataEvent {
  const AccountDataFetchRequestSubmitted(this.consent);

  final ConsentDetails consent;

  @override
  List<Object> get props => [consent];
}

final class AccountDataFetchSubmitted extends AccountDataEvent {
  const AccountDataFetchSubmitted();
}
