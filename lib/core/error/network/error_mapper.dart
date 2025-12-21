

import 'package:dun_diary_app/core/error/network/exceptions.dart';

class ErrorMapper {
  
  static String map(Object error) {
    if (error is ServerException) {
      return _mapServerCode(error.error.code, error.error.message);
    }
    
    if (error is NetworkException) {
      return "No Internet Connection. Please check your network settings.";
    }

    return "Error: ${error.toString()}";
  }

  // Can map server error code to user-friendly message
  static String _mapServerCode(String code, String defaultMessage) {
    return switch (code) {
      'AUTH_001' => 'Email or password is incorrect',
      'AUTH_002' => 'This account has been disabled',
      'USER_DUP' => 'This email is already registered',
      'INV_INPUT'=> 'Please check your input data',
      _          => defaultMessage, 
    };
  }
}