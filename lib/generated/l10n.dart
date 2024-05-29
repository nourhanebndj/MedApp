// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `near you!`
  String get nearyour {
    return Intl.message(
      'near you!',
      name: 'nearyour',
      desc: '',
      args: [],
    );
  }

  /// `find your doctor quickly\n`
  String get findyourquicklyyourdoctor {
    return Intl.message(
      'find your doctor quickly\n',
      name: 'findyourquicklyyourdoctor',
      desc: '',
      args: [],
    );
  }

  /// `Are you a doctor?`
  String get Areyouadoctor {
    return Intl.message(
      'Are you a doctor?',
      name: 'Areyouadoctor',
      desc: '',
      args: [],
    );
  }

  /// `Welcome Doctor`
  String get Welcome_Doctor {
    return Intl.message(
      'Welcome Doctor',
      name: 'Welcome_Doctor',
      desc: '',
      args: [],
    );
  }

  /// `Your trusted companion for efficient and intuitive medical practice.`
  String
      get Your_trusted_companion_for_efficient_and_intuitive_medical_practice {
    return Intl.message(
      'Your trusted companion for efficient and intuitive medical practice.',
      name:
          'Your_trusted_companion_for_efficient_and_intuitive_medical_practice',
      desc: '',
      args: [],
    );
  }

  /// `Welcome Pharmacist`
  String get Welcome_Pharmacist {
    return Intl.message(
      'Welcome Pharmacist',
      name: 'Welcome_Pharmacist',
      desc: '',
      args: [],
    );
  }

  /// `Error loading appointments: `
  String get loadingAppointmentsError {
    return Intl.message(
      'Error loading appointments: ',
      name: 'loadingAppointmentsError',
      desc: '',
      args: [],
    );
  }

  /// `Error updating appointment status: `
  String get updatingAppointmentStatusError {
    return Intl.message(
      'Error updating appointment status: ',
      name: 'updatingAppointmentStatusError',
      desc: '',
      args: [],
    );
  }

  /// `has been`
  String get appointmentStatusUpdated {
    return Intl.message(
      'has been',
      name: 'appointmentStatusUpdated',
      desc: '',
      args: [],
    );
  }

  /// ` Your appointement`
  String get appointement {
    return Intl.message(
      ' Your appointement',
      name: 'appointement',
      desc: '',
      args: [],
    );
  }

  /// `Appointment Approaching`
  String get appointmentApproachingTitle {
    return Intl.message(
      'Appointment Approaching',
      name: 'appointmentApproachingTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your appointment is in `
  String get appointmentApproachingBody {
    return Intl.message(
      'Your appointment is in ',
      name: 'appointmentApproachingBody',
      desc: '',
      args: [],
    );
  }

  /// `New medication request received from`
  String get newRequestReceived {
    return Intl.message(
      'New medication request received from',
      name: 'newRequestReceived',
      desc: '',
      args: [],
    );
  }

  /// `New medication request received.`
  String get newMedicationRequestReceived {
    return Intl.message(
      'New medication request received.',
      name: 'newMedicationRequestReceived',
      desc: '',
      args: [],
    );
  }

  /// `Your request status has been updated.`
  String get requestStatusUpdated {
    return Intl.message(
      'Your request status has been updated.',
      name: 'requestStatusUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Please add a note before accepting the request`
  String get pleaseAddNoteBeforeAcceptingRequest {
    return Intl.message(
      'Please add a note before accepting the request',
      name: 'pleaseAddNoteBeforeAcceptingRequest',
      desc: '',
      args: [],
    );
  }

  /// `Please add a note before rejecting the request`
  String get pleaseAddNoteBeforeRejectingRequest {
    return Intl.message(
      'Please add a note before rejecting the request',
      name: 'pleaseAddNoteBeforeRejectingRequest',
      desc: '',
      args: [],
    );
  }

  /// `New medication request`
  String get newMedicationRequest {
    return Intl.message(
      'New medication request',
      name: 'newMedicationRequest',
      desc: '',
      args: [],
    );
  }

  /// `Unavailable Medication List`
  String get Liste_des_medicament_non_disponible {
    return Intl.message(
      'Unavailable Medication List',
      name: 'Liste_des_medicament_non_disponible',
      desc: '',
      args: [],
    );
  }

  /// `Medication Requests`
  String get title {
    return Intl.message(
      'Medication Requests',
      name: 'title',
      desc: '',
      args: [],
    );
  }

  /// `Your request has been rejected. Note:`
  String get requestRejected {
    return Intl.message(
      'Your request has been rejected. Note:',
      name: 'requestRejected',
      desc: '',
      args: [],
    );
  }

  /// `Your request has been accepted.Note`
  String get requestAccepted {
    return Intl.message(
      'Your request has been accepted.Note',
      name: 'requestAccepted',
      desc: '',
      args: [],
    );
  }

  /// `Request Rejected`
  String get requestRejectedTitle {
    return Intl.message(
      'Request Rejected',
      name: 'requestRejectedTitle',
      desc: '',
      args: [],
    );
  }

  /// `Request Accepted`
  String get requestAcceptedTitle {
    return Intl.message(
      'Request Accepted',
      name: 'requestAcceptedTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your trusted ally for efficient pharmacy management and delivering optimal patient care`
  String get description {
    return Intl.message(
      'Your trusted ally for efficient pharmacy management and delivering optimal patient care',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Are you a patient?`
  String get Areyouauser {
    return Intl.message(
      'Are you a patient?',
      name: 'Areyouauser',
      desc: '',
      args: [],
    );
  }

  /// `Are you a pharmacist?`
  String get Areyouapharmacist {
    return Intl.message(
      'Are you a pharmacist?',
      name: 'Areyouapharmacist',
      desc: '',
      args: [],
    );
  }

  /// `Registration`
  String get registration {
    return Intl.message(
      'Registration',
      name: 'registration',
      desc: '',
      args: [],
    );
  }

  /// `we need to register your phone without getting started`
  String get we_need_to_register_your_phone_without_getting_started {
    return Intl.message(
      'we need to register your phone without getting started',
      name: 'we_need_to_register_your_phone_without_getting_started',
      desc: '',
      args: [],
    );
  }

  /// `username`
  String get username {
    return Intl.message(
      'username',
      name: 'username',
      desc: '',
      args: [],
    );
  }

  /// `phone`
  String get phone {
    return Intl.message(
      'phone',
      name: 'phone',
      desc: '',
      args: [],
    );
  }

  /// `Send Verification Code`
  String get Send_Verification_Code {
    return Intl.message(
      'Send Verification Code',
      name: 'Send_Verification_Code',
      desc: '',
      args: [],
    );
  }

  /// `Choose Work Days`
  String get Choose_Work_Days {
    return Intl.message(
      'Choose Work Days',
      name: 'Choose_Work_Days',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get Done {
    return Intl.message(
      'Done',
      name: 'Done',
      desc: '',
      args: [],
    );
  }

  /// `Select Your Location`
  String get Select_Your_Location {
    return Intl.message(
      'Select Your Location',
      name: 'Select_Your_Location',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to MedApp`
  String get Welcome_to_your_application {
    return Intl.message(
      'Welcome to MedApp',
      name: 'Welcome_to_your_application',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get Name {
    return Intl.message(
      'Name',
      name: 'Name',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get Email {
    return Intl.message(
      'Email',
      name: 'Email',
      desc: '',
      args: [],
    );
  }

  /// `Select Work Days`
  String get Select_Work_Days {
    return Intl.message(
      'Select Work Days',
      name: 'Select_Work_Days',
      desc: '',
      args: [],
    );
  }

  /// `Select Start Time`
  String get Select_Start_Time {
    return Intl.message(
      'Select Start Time',
      name: 'Select_Start_Time',
      desc: '',
      args: [],
    );
  }

  /// `Select End Time`
  String get Select_End_Time {
    return Intl.message(
      'Select End Time',
      name: 'Select_End_Time',
      desc: '',
      args: [],
    );
  }

  /// `Phone_Number`
  String get Phone_Number {
    return Intl.message(
      'Phone_Number',
      name: 'Phone_Number',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get Password {
    return Intl.message(
      'Password',
      name: 'Password',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get SignUp {
    return Intl.message(
      'Sign Up',
      name: 'SignUp',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account`
  String get Already_have_an_account {
    return Intl.message(
      'Already have an account',
      name: 'Already_have_an_account',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get Login {
    return Intl.message(
      'Login',
      name: 'Login',
      desc: '',
      args: [],
    );
  }

  /// `Dont have account?`
  String get Dont_have_an_account {
    return Intl.message(
      'Dont have account?',
      name: 'Dont_have_an_account',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password`
  String get Forgot_Password {
    return Intl.message(
      'Forgot Password',
      name: 'Forgot_Password',
      desc: '',
      args: [],
    );
  }

  /// `Verification code`
  String get Verification_code {
    return Intl.message(
      'Verification code',
      name: 'Verification_code',
      desc: '',
      args: [],
    );
  }

  /// `Enter SMS Code`
  String get Enter_SMS_Code {
    return Intl.message(
      'Enter SMS Code',
      name: 'Enter_SMS_Code',
      desc: '',
      args: [],
    );
  }

  /// `Verify Phone Number`
  String get Verify_Phone_Number {
    return Intl.message(
      'Verify Phone Number',
      name: 'Verify_Phone_Number',
      desc: '',
      args: [],
    );
  }

  /// `Forgot your password`
  String get Forgot_your_password {
    return Intl.message(
      'Forgot your password',
      name: 'Forgot_your_password',
      desc: '',
      args: [],
    );
  }

  /// `Enter your mail`
  String get Enter_your_mail {
    return Intl.message(
      'Enter your mail',
      name: 'Enter_your_mail',
      desc: '',
      args: [],
    );
  }

  /// `Send Email`
  String get Send_Email {
    return Intl.message(
      'Send Email',
      name: 'Send_Email',
      desc: '',
      args: [],
    );
  }

  /// `Create`
  String get Create {
    return Intl.message(
      'Create',
      name: 'Create',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get Home {
    return Intl.message(
      'Home',
      name: 'Home',
      desc: '',
      args: [],
    );
  }

  /// `Pharmacist`
  String get Pharmacist {
    return Intl.message(
      'Pharmacist',
      name: 'Pharmacist',
      desc: '',
      args: [],
    );
  }

  /// `Map`
  String get Map {
    return Intl.message(
      'Map',
      name: 'Map',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get Profile {
    return Intl.message(
      'Profile',
      name: 'Profile',
      desc: '',
      args: [],
    );
  }

  /// `Hello`
  String get Hello {
    return Intl.message(
      'Hello',
      name: 'Hello',
      desc: '',
      args: [],
    );
  }

  /// `How do you feel today ?`
  String get How_do_you_feel_today {
    return Intl.message(
      'How do you feel today ?',
      name: 'How_do_you_feel_today',
      desc: '',
      args: [],
    );
  }

  /// `Search doctor`
  String get Search_doctor {
    return Intl.message(
      'Search doctor',
      name: 'Search_doctor',
      desc: '',
      args: [],
    );
  }

  /// `Categories`
  String get Categories {
    return Intl.message(
      'Categories',
      name: 'Categories',
      desc: '',
      args: [],
    );
  }

  /// `View All`
  String get View_All {
    return Intl.message(
      'View All',
      name: 'View_All',
      desc: '',
      args: [],
    );
  }

  /// `Top Doctor`
  String get Top_Doctor {
    return Intl.message(
      'Top Doctor',
      name: 'Top_Doctor',
      desc: '',
      args: [],
    );
  }

  /// `Top pharmacist`
  String get Top_pharmacist {
    return Intl.message(
      'Top pharmacist',
      name: 'Top_pharmacist',
      desc: '',
      args: [],
    );
  }

  /// `Dr`
  String get Dr {
    return Intl.message(
      'Dr',
      name: 'Dr',
      desc: '',
      args: [],
    );
  }

  /// `Specialty`
  String get Specialty {
    return Intl.message(
      'Specialty',
      name: 'Specialty',
      desc: '',
      args: [],
    );
  }

  /// `Days`
  String get Days {
    return Intl.message(
      'Days',
      name: 'Days',
      desc: '',
      args: [],
    );
  }

  /// `Hours`
  String get Hours {
    return Intl.message(
      'Hours',
      name: 'Hours',
      desc: '',
      args: [],
    );
  }

  /// `All Doctors`
  String get All_Doctors {
    return Intl.message(
      'All Doctors',
      name: 'All_Doctors',
      desc: '',
      args: [],
    );
  }

  /// `All pharmacists`
  String get All_pharmacist {
    return Intl.message(
      'All pharmacists',
      name: 'All_pharmacist',
      desc: '',
      args: [],
    );
  }

  /// `My All Request`
  String get My_All_Request {
    return Intl.message(
      'My All Request',
      name: 'My_All_Request',
      desc: '',
      args: [],
    );
  }

  /// `My appointement`
  String get My_appointement {
    return Intl.message(
      'My appointement',
      name: 'My_appointement',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get Logout {
    return Intl.message(
      'Logout',
      name: 'Logout',
      desc: '',
      args: [],
    );
  }

  /// `No user logged in`
  String get No_user_logged_in {
    return Intl.message(
      'No user logged in',
      name: 'No_user_logged_in',
      desc: '',
      args: [],
    );
  }

  /// `Search pharmacist...`
  String get Search_pharmacist {
    return Intl.message(
      'Search pharmacist...',
      name: 'Search_pharmacist',
      desc: '',
      args: [],
    );
  }

  /// `work day`
  String get work_days {
    return Intl.message(
      'work day',
      name: 'work_days',
      desc: '',
      args: [],
    );
  }

  /// `start time`
  String get starttime {
    return Intl.message(
      'start time',
      name: 'starttime',
      desc: '',
      args: [],
    );
  }

  /// `end time`
  String get endtime {
    return Intl.message(
      'end time',
      name: 'endtime',
      desc: '',
      args: [],
    );
  }

  /// `Consult Your Requests`
  String get Consult_Your_Requests {
    return Intl.message(
      'Consult Your Requests',
      name: 'Consult_Your_Requests',
      desc: '',
      args: [],
    );
  }

  /// `Consult Your Appointments`
  String get Consult_Your_Appointments {
    return Intl.message(
      'Consult Your Appointments',
      name: 'Consult_Your_Appointments',
      desc: '',
      args: [],
    );
  }

  /// `Category`
  String get category {
    return Intl.message(
      'Category',
      name: 'category',
      desc: '',
      args: [],
    );
  }

  /// `Available From:`
  String get Available_From {
    return Intl.message(
      'Available From:',
      name: 'Available_From',
      desc: '',
      args: [],
    );
  }

  /// `Available Until: `
  String get Available_Until {
    return Intl.message(
      'Available Until: ',
      name: 'Available_Until',
      desc: '',
      args: [],
    );
  }

  /// `Medication Request`
  String get Medication_Request {
    return Intl.message(
      'Medication Request',
      name: 'Medication_Request',
      desc: '',
      args: [],
    );
  }

  /// `About the Pharmacist`
  String get About_the_Pharmacist {
    return Intl.message(
      'About the Pharmacist',
      name: 'About_the_Pharmacist',
      desc: '',
      args: [],
    );
  }

  /// `Select Location`
  String get Select_Location {
    return Intl.message(
      'Select Location',
      name: 'Select_Location',
      desc: '',
      args: [],
    );
  }

  /// `Please select at least one workday`
  String get Please_select_at_least_one_workday {
    return Intl.message(
      'Please select at least one workday',
      name: 'Please_select_at_least_one_workday',
      desc: '',
      args: [],
    );
  }

  /// `Please select a location`
  String get Please_select_a_location {
    return Intl.message(
      'Please select a location',
      name: 'Please_select_a_location',
      desc: '',
      args: [],
    );
  }

  /// `Please select both start and end time`
  String get Please_select_both_start_and_end_time {
    return Intl.message(
      'Please select both start and end time',
      name: 'Please_select_both_start_and_end_time',
      desc: '',
      args: [],
    );
  }

  /// `No doctor found, please reset`
  String get No_doctor_found_please_reset {
    return Intl.message(
      'No doctor found, please reset',
      name: 'No_doctor_found_please_reset',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get Search {
    return Intl.message(
      'Search',
      name: 'Search',
      desc: '',
      args: [],
    );
  }

  /// `Pharmacist Name : `
  String get Pharmacist_Name {
    return Intl.message(
      'Pharmacist Name : ',
      name: 'Pharmacist_Name',
      desc: '',
      args: [],
    );
  }

  /// `Enter pharmacist name`
  String get Enter_pharmacist_name {
    return Intl.message(
      'Enter pharmacist name',
      name: 'Enter_pharmacist_name',
      desc: '',
      args: [],
    );
  }

  /// `Select Hours`
  String get Select_Hours {
    return Intl.message(
      'Select Hours',
      name: 'Select_Hours',
      desc: '',
      args: [],
    );
  }

  /// `Start`
  String get Start {
    return Intl.message(
      'Start',
      name: 'Start',
      desc: '',
      args: [],
    );
  }

  /// `End`
  String get End {
    return Intl.message(
      'End',
      name: 'End',
      desc: '',
      args: [],
    );
  }

  /// `Search Doctor`
  String get Search_Doctor {
    return Intl.message(
      'Search Doctor',
      name: 'Search_Doctor',
      desc: '',
      args: [],
    );
  }

  /// `Enter doctor name`
  String get Enter_doctor_name {
    return Intl.message(
      'Enter doctor name',
      name: 'Enter_doctor_name',
      desc: '',
      args: [],
    );
  }

  /// `Workdays`
  String get Workdays {
    return Intl.message(
      'Workdays',
      name: 'Workdays',
      desc: '',
      args: [],
    );
  }

  /// `No doctor found, please reset`
  String get No_doctor_found {
    return Intl.message(
      'No doctor found, please reset',
      name: 'No_doctor_found',
      desc: '',
      args: [],
    );
  }

  /// `Please select a category`
  String get Please_select_category {
    return Intl.message(
      'Please select a category',
      name: 'Please_select_category',
      desc: '',
      args: [],
    );
  }

  /// `Please select a location`
  String get Please_select_location {
    return Intl.message(
      'Please select a location',
      name: 'Please_select_location',
      desc: '',
      args: [],
    );
  }

  /// `Patient Information`
  String get patientInformation {
    return Intl.message(
      'Patient Information',
      name: 'patientInformation',
      desc: '',
      args: [],
    );
  }

  /// `First Name`
  String get firstName {
    return Intl.message(
      'First Name',
      name: 'firstName',
      desc: '',
      args: [],
    );
  }

  /// `Last Name`
  String get lastName {
    return Intl.message(
      'Last Name',
      name: 'lastName',
      desc: '',
      args: [],
    );
  }

  /// `Sex`
  String get sexe {
    return Intl.message(
      'Sex',
      name: 'sexe',
      desc: '',
      args: [],
    );
  }

  /// `Age`
  String get age {
    return Intl.message(
      'Age',
      name: 'age',
      desc: '',
      args: [],
    );
  }

  /// `Select Work Time`
  String get selectWorkTime {
    return Intl.message(
      'Select Work Time',
      name: 'selectWorkTime',
      desc: '',
      args: [],
    );
  }

  /// `Appointment Registered Successfully`
  String get appointmentRegistered {
    return Intl.message(
      'Appointment Registered Successfully',
      name: 'appointmentRegistered',
      desc: '',
      args: [],
    );
  }

  /// `Back to Home Page`
  String get backToHomePage {
    return Intl.message(
      'Back to Home Page',
      name: 'backToHomePage',
      desc: '',
      args: [],
    );
  }

  /// `About the Doctor`
  String get aboutDoctor {
    return Intl.message(
      'About the Doctor',
      name: 'aboutDoctor',
      desc: '',
      args: [],
    );
  }

  /// `Book Appointment`
  String get bookAppointment {
    return Intl.message(
      'Book Appointment',
      name: 'bookAppointment',
      desc: '',
      args: [],
    );
  }

  /// `Select from Gallery`
  String get Select_from_Gallery {
    return Intl.message(
      'Select from Gallery',
      name: 'Select_from_Gallery',
      desc: '',
      args: [],
    );
  }

  /// `Take a Photo`
  String get Take_a_Photo {
    return Intl.message(
      'Take a Photo',
      name: 'Take_a_Photo',
      desc: '',
      args: [],
    );
  }

  /// `List of Medicines`
  String get List_of_Medicines {
    return Intl.message(
      'List of Medicines',
      name: 'List_of_Medicines',
      desc: '',
      args: [],
    );
  }

  /// `Submit Request`
  String get Submit_Request {
    return Intl.message(
      'Submit Request',
      name: 'Submit_Request',
      desc: '',
      args: [],
    );
  }

  /// `My Appointments`
  String get myAppointments {
    return Intl.message(
      'My Appointments',
      name: 'myAppointments',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message(
      'Error',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `No appointments found`
  String get noAppointmentsFound {
    return Intl.message(
      'No appointments found',
      name: 'noAppointmentsFound',
      desc: '',
      args: [],
    );
  }

  /// `Doctor not found`
  String get doctorNotFound {
    return Intl.message(
      'Doctor not found',
      name: 'doctorNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Time`
  String get accessTime {
    return Intl.message(
      'Time',
      name: 'accessTime',
      desc: '',
      args: [],
    );
  }

  /// `Day`
  String get calendarMonth {
    return Intl.message(
      'Day',
      name: 'calendarMonth',
      desc: '',
      args: [],
    );
  }

  /// `Accepted`
  String get accepted {
    return Intl.message(
      'Accepted',
      name: 'accepted',
      desc: '',
      args: [],
    );
  }

  /// `Rejected`
  String get rejected {
    return Intl.message(
      'Rejected',
      name: 'rejected',
      desc: '',
      args: [],
    );
  }

  /// `Pending`
  String get pending {
    return Intl.message(
      'Pending',
      name: 'pending',
      desc: '',
      args: [],
    );
  }

  /// `Doctor`
  String get Doctor {
    return Intl.message(
      'Doctor',
      name: 'Doctor',
      desc: '',
      args: [],
    );
  }

  /// `My Medication Requests`
  String get myMedicationRequests {
    return Intl.message(
      'My Medication Requests',
      name: 'myMedicationRequests',
      desc: '',
      args: [],
    );
  }

  /// `No medication requests found`
  String get noMedicationRequestsFound {
    return Intl.message(
      'No medication requests found',
      name: 'noMedicationRequestsFound',
      desc: '',
      args: [],
    );
  }

  /// `All medication requests`
  String get allMedicationRequests {
    return Intl.message(
      'All medication requests',
      name: 'allMedicationRequests',
      desc: '',
      args: [],
    );
  }

  /// `Pharmacist not found`
  String get pharmacistNotFound {
    return Intl.message(
      'Pharmacist not found',
      name: 'pharmacistNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Note`
  String get note {
    return Intl.message(
      'Note',
      name: 'note',
      desc: '',
      args: [],
    );
  }

  /// `Patient`
  String get patient {
    return Intl.message(
      'Patient',
      name: 'patient',
      desc: '',
      args: [],
    );
  }

  /// `Pharmacist`
  String get pharmacist {
    return Intl.message(
      'Pharmacist',
      name: 'pharmacist',
      desc: '',
      args: [],
    );
  }

  /// `List of Medications`
  String get medicationList {
    return Intl.message(
      'List of Medications',
      name: 'medicationList',
      desc: '',
      args: [],
    );
  }

  /// `years`
  String get years {
    return Intl.message(
      'years',
      name: 'years',
      desc: '',
      args: [],
    );
  }

  /// `Time`
  String get time {
    return Intl.message(
      'Time',
      name: 'time',
      desc: '',
      args: [],
    );
  }

  /// `Day`
  String get day {
    return Intl.message(
      'Day',
      name: 'day',
      desc: '',
      args: [],
    );
  }

  /// `Accept`
  String get accept {
    return Intl.message(
      'Accept',
      name: 'accept',
      desc: '',
      args: [],
    );
  }

  /// `Reject`
  String get reject {
    return Intl.message(
      'Reject',
      name: 'reject',
      desc: '',
      args: [],
    );
  }

  /// `save note`
  String get saveNote {
    return Intl.message(
      'save note',
      name: 'saveNote',
      desc: '',
      args: [],
    );
  }

  /// `close `
  String get closeButton {
    return Intl.message(
      'close ',
      name: 'closeButton',
      desc: '',
      args: [],
    );
  }

  /// `No notifications found at the moment.`
  String get noNotifications {
    return Intl.message(
      'No notifications found at the moment.',
      name: 'noNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Request Notifications`
  String get requestNotifications {
    return Intl.message(
      'Request Notifications',
      name: 'requestNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Appointment Notifications`
  String get appointmentNotifications {
    return Intl.message(
      'Appointment Notifications',
      name: 'appointmentNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notificationsTitle {
    return Intl.message(
      'Notifications',
      name: 'notificationsTitle',
      desc: '',
      args: [],
    );
  }

  /// `No doctor found in your zone`
  String get No_doctor_found_in_your_zone {
    return Intl.message(
      'No doctor found in your zone',
      name: 'No_doctor_found_in_your_zone',
      desc: '',
      args: [],
    );
  }

  /// `No pharmacist found in your zone`
  String get No_pharmacist_found_in_your_zone {
    return Intl.message(
      'No pharmacist found in your zone',
      name: 'No_pharmacist_found_in_your_zone',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to the laboratory`
  String get Welcome_laboratory {
    return Intl.message(
      'Welcome to the laboratory',
      name: 'Welcome_laboratory',
      desc: '',
      args: [],
    );
  }

  /// `Are you laboratory`
  String get Areyoulaboraty {
    return Intl.message(
      'Are you laboratory',
      name: 'Areyoulaboraty',
      desc: '',
      args: [],
    );
  }

  /// `Your trusted companion for finding laboratories efficiently and intuitively`
  String
      get Your_trusted_companion_for_finding_laboratories_efficiently_and_intuitively {
    return Intl.message(
      'Your trusted companion for finding laboratories efficiently and intuitively',
      name:
          'Your_trusted_companion_for_finding_laboratories_efficiently_and_intuitively',
      desc: '',
      args: [],
    );
  }

  /// `Edit Profil`
  String get EditProfil {
    return Intl.message(
      'Edit Profil',
      name: 'EditProfil',
      desc: '',
      args: [],
    );
  }

  /// `Top Laboratory`
  String get Top_laboratory {
    return Intl.message(
      'Top Laboratory',
      name: 'Top_laboratory',
      desc: '',
      args: [],
    );
  }

  /// `Laboratory`
  String get Laboratory {
    return Intl.message(
      'Laboratory',
      name: 'Laboratory',
      desc: '',
      args: [],
    );
  }

  /// `No laboratory found in your zone`
  String get No_laboratory_found_in_your_zone {
    return Intl.message(
      'No laboratory found in your zone',
      name: 'No_laboratory_found_in_your_zone',
      desc: '',
      args: [],
    );
  }

  /// `Search laboratory`
  String get Search_laboratory {
    return Intl.message(
      'Search laboratory',
      name: 'Search_laboratory',
      desc: '',
      args: [],
    );
  }

  /// `Enter laboratory name`
  String get Enter_laboratory_name {
    return Intl.message(
      'Enter laboratory name',
      name: 'Enter_laboratory_name',
      desc: '',
      args: [],
    );
  }

  /// `No laboratory found, please reset`
  String get No_laboratory_found {
    return Intl.message(
      'No laboratory found, please reset',
      name: 'No_laboratory_found',
      desc: '',
      args: [],
    );
  }

  /// `All laboratory`
  String get All_laboratory {
    return Intl.message(
      'All laboratory',
      name: 'All_laboratory',
      desc: '',
      args: [],
    );
  }

  /// `location:`
  String get Emplacement {
    return Intl.message(
      'location:',
      name: 'Emplacement',
      desc: '',
      args: [],
    );
  }

  /// `Search name of doctor,pharmacist or laboratory`
  String get search_doctor_or_pharmacist_laboratory {
    return Intl.message(
      'Search name of doctor,pharmacist or laboratory',
      name: 'search_doctor_or_pharmacist_laboratory',
      desc: '',
      args: [],
    );
  }

  /// `Edit Profil`
  String get edit_profil {
    return Intl.message(
      'Edit Profil',
      name: 'edit_profil',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Deletion`
  String get confirmDeletion {
    return Intl.message(
      'Confirm Deletion',
      name: 'confirmDeletion',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this account? This action cannot be undone.`
  String get confirmDeletionMessage {
    return Intl.message(
      'Are you sure you want to delete this account? This action cannot be undone.',
      name: 'confirmDeletionMessage',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Account Deleted Successfully`
  String get deleteSuccess {
    return Intl.message(
      'Account Deleted Successfully',
      name: 'deleteSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Error deleting account`
  String get deleteError {
    return Intl.message(
      'Error deleting account',
      name: 'deleteError',
      desc: '',
      args: [],
    );
  }

  /// `Save Change`
  String get saveChange {
    return Intl.message(
      'Save Change',
      name: 'saveChange',
      desc: '',
      args: [],
    );
  }

  /// `Profile Updated Successfully`
  String get profileUpdated {
    return Intl.message(
      'Profile Updated Successfully',
      name: 'profileUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Error updating profile`
  String get updateError {
    return Intl.message(
      'Error updating profile',
      name: 'updateError',
      desc: '',
      args: [],
    );
  }

  /// `Resend code`
  String get Resend_code {
    return Intl.message(
      'Resend code',
      name: 'Resend_code',
      desc: '',
      args: [],
    );
  }

  /// `No scheduled notifications`
  String get No_scheduled_notifications {
    return Intl.message(
      'No scheduled notifications',
      name: 'No_scheduled_notifications',
      desc: '',
      args: [],
    );
  }

  /// `Scheduled Notifications`
  String get Scheduled_Notifications {
    return Intl.message(
      'Scheduled Notifications',
      name: 'Scheduled_Notifications',
      desc: '',
      args: [],
    );
  }

  /// `Dont forget your appointment at`
  String get Dont_forget_your_appointment_at {
    return Intl.message(
      'Dont forget your appointment at',
      name: 'Dont_forget_your_appointment_at',
      desc: '',
      args: [],
    );
  }

  /// `reminded`
  String get Reminded {
    return Intl.message(
      'reminded',
      name: 'Reminded',
      desc: '',
      args: [],
    );
  }

  /// `expired`
  String get expired {
    return Intl.message(
      'expired',
      name: 'expired',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'arb'),
      Locale.fromSubtags(languageCode: 'fr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
