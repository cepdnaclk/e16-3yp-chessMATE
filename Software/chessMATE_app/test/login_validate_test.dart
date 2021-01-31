import 'package:chessMATE_app/login/login_validate.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){

  test('email ', () {
    bool result1 = validate_email( "a");
    expect(result1,false);

    bool result2 = validate_email( "abc@gmail.com");
    expect(result2,true);

  });


 test('password', () {
     bool result1 = validate_password( "a");
    expect(result1,false);

    bool result2 = validate_password( "ab&1");
    expect(result2,true);
  });

  test('Login', () {
     int result1 = validate_login("", "" );
    expect(result1,2);

    int result2 = validate_login( "abc@gmail.com", "11");
    expect(result2,1);

    int result3 = validate_login( "abc@gm", "ab#12");
    expect(result3,0);

    int result4 = validate_login( "abc@gmail.com", "abc123");
    expect(result4,4);
  });



}