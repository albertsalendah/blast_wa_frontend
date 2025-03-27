enum ConnectionStatus { connecting, open, close, qr }

//path
const String loginPath = '/auth/login';
const String registerPath = '/auth/register';
const String logoutPath = '/auth/logout';
const String accessTokenPath = '/auth/get-new-access-token';
const String getUserPath = '/auth/get-user';
const String getPhoneNumbersPath = '/auth/get-phone-number';
const String sendMessagePath = '/send-message';
const String getMessageHistoryGroupPath = '/get-message-history-group';
const String getMessageHistoryPath = '/get-message-history';
const String deleteMessageHistoryPath = '/delete-message-history';
