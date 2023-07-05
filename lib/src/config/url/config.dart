/*
  DEPLOY
*/
const baseUrl = "http://192.168.1.19:8080";

const urlLogin = '$baseUrl/api/auth/login'; // post

const urlSignUp = '$baseUrl/api/auth/register'; // post

const urlGetMessage = '$baseUrl/api/message';

const urlGetChatRoom = '$baseUrl/api/chat_room';

const urlEditAvatar = '$baseUrl/api/user/edit_avatar';
const urlGetListBooking = '$baseUrl/api/booking/getAllListBooking';
const urlAddNewBooking = '$baseUrl/api/booking/createBooking';
const urlGetBookingInApply = '$baseUrl/api/apply/getBookingInApply';
