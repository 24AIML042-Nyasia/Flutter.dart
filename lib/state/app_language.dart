import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// APPLICATION STATE: selected language.
// languageNotifier holds the current choice. LanguageScope (placed above the
// whole app in main.dart) passes it down, and every screen that calls tr()
// is rebuilt automatically when the language changes.
// ---------------------------------------------------------------------------

const List<String> appLanguages = ['English', 'Hindi', 'Gujarati'];

final ValueNotifier<String> languageNotifier = ValueNotifier('English');

class LanguageScope extends InheritedWidget {
  final String language;

  const LanguageScope({
    super.key,
    required this.language,
    required super.child,
  });

  static String of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<LanguageScope>();
    return scope?.language ?? 'English';
  }

  @override
  bool updateShouldNotify(LanguageScope oldWidget) =>
      oldWidget.language != language;
}

/// Looks up [key] in the current language. Order: English, Hindi, Gujarati.
String tr(BuildContext context, String key) {
  final values = _strings[key];
  if (values == null) return key;
  final index = appLanguages.indexOf(LanguageScope.of(context));
  return values[index < 0 ? 0 : index];
}

const Map<String, List<String>> _strings = {
  // Dashboard
  'dashboardTitle': ['Course Dashboard', 'कोर्स डैशबोर्ड', 'કોર્સ ડેશબોર્ડ'],
  'modules': ['Modules', 'मॉड्यूल', 'મોડ્યુલ્સ'],
  'attendance': ['Attendance', 'उपस्थिति', 'હાજરી'],
  'timetable': ['Timetable', 'समय सारणी', 'સમયપત્રક'],
  'assignments': ['Assignments', 'असाइनमेंट', 'અસાઇનમેન્ટ'],
  'faculty': ['Faculty', 'शिक्षक', 'ફેકલ્ટી'],
  'events': ['Event Gallery', 'इवेंट गैलरी', 'ઇવેન્ટ ગેલેરી'],
  'settings': ['Settings', 'सेटिंग्स', 'સેટિંગ્સ'],
  'preferences': ['Preferences', 'प्राथमिकताएं', 'પસંદગીઓ'],
  'meetTeachers': ['Meet your teachers', 'अपने शिक्षकों से मिलें', 'તમારા શિક્ષકોને મળો'],
  'upcomingEvents': ['6 upcoming events', '6 आगामी इवेंट', '6 આગામી ઇવેન્ટ્સ'],
  'toTrack': ['3 to track', '3 ट्रैक करने हैं', '3 ટ્રેક કરવાના'],
  'goodStanding': ['Good standing', 'अच्छी स्थिति', 'સારી સ્થિતિ'],
  'warning': ['Warning', 'चेतावनी', 'ચેતવણી'],
  'detainedRisk': ['Detained risk', 'रोके जाने का जोखिम', 'અટકાવવાનું જોખમ'],

  // Notifications and profile
  'notifications': ['Notifications', 'सूचनाएं', 'સૂચનાઓ'],
  'noNotifications': ['No new notifications.', 'कोई नई सूचना नहीं।', 'કોઈ નવી સૂચના નથી.'],
  'studentProfile': ['Student Profile', 'छात्र प्रोफ़ाइल', 'વિદ્યાર્થી પ્રોફાઇલ'],
  'logout': ['Log out', 'लॉग आउट', 'લૉગ આઉટ'],
  'confirmLogout': ['Are you sure you want to log out?', 'क्या आप लॉग आउट करना चाहते हैं?', 'શું તમે ખરેખર લૉગ આઉટ કરવા માંગો છો?'],
  'cancel': ['Cancel', 'रद्द करें', 'રદ કરો'],
  'email': ['Email', 'ईमेल', 'ઇમેઇલ'],
  'semester': ['Semester', 'सेमेस्टर', 'સેમેસ્ટર'],
  'subjects': ['Subjects', 'विषय', 'વિષયો'],

  // Settings
  'profileSettings': ['Student Profile Settings', 'छात्र प्रोफ़ाइल सेटिंग्स', 'વિદ્યાર્થી પ્રોફાઇલ સેટિંગ્સ'],
  'fullName': ['Full Name', 'पूरा नाम', 'પૂરું નામ'],
  'enrollmentNo': ['Enrollment No.', 'नामांकन संख्या', 'નોંધણી નંબર'],
  'department': ['Department', 'विभाग', 'વિભાગ'],
  'saveProfile': ['Save profile', 'प्रोफ़ाइल सहेजें', 'પ્રોફાઇલ સાચવો'],
  'profileUpdated': ['Profile updated', 'प्रोफ़ाइल अपडेट हो गई', 'પ્રોફાઇલ અપડેટ થઈ'],
  'themeSelection': ['Theme Selection', 'थीम चयन', 'થીમ પસંદગી'],
  'darkMode': ['Dark mode', 'डार्क मोड', 'ડાર્ક મોડ'],
  'darkOn': ['Dark theme on', 'डार्क थीम चालू', 'ડાર્ક થીમ ચાલુ'],
  'lightOn': ['Light theme on', 'लाइट थीम चालू', 'લાઇટ થીમ ચાલુ'],
  'languageSelection': ['Language Selection', 'भाषा चयन', 'ભાષા પસંદગી'],
  'notificationPrefs': ['Notification Preferences', 'सूचना प्राथमिकताएं', 'સૂચના પસંદગીઓ'],
  'assignmentAlerts': ['Assignment Alerts', 'असाइनमेंट अलर्ट', 'અસાઇનમેન્ટ એલર્ટ'],
  'examNotifications': ['Examination Notifications', 'परीक्षा सूचनाएं', 'પરીક્ષા સૂચનાઓ'],
  'placementUpdates': ['Placement Updates', 'प्लेसमेंट अपडेट', 'પ્લેસમેન્ટ અપડેટ્સ'],
  'eventAnnouncements': ['Event Announcements', 'इवेंट घोषणाएं', 'ઇવેન્ટ જાહેરાતો'],
  'coursePrefs': ['Course Preferences', 'कोर्स प्राथमिकताएं', 'કોર્સ પસંદગીઓ'],
  'courseMad': ['Mobile Application Development', 'मोबाइल एप्लिकेशन डेवलपमेंट', 'મોબાઇલ એપ્લિકેશન ડેવલપમેન્ટ'],
  'courseAi': ['Artificial Intelligence', 'आर्टिफिशियल इंटेलिजेंस', 'આર્ટિફિશિયલ ઇન્ટેલિજન્સ'],
  'courseDbms': ['Database Management System', 'डेटाबेस मैनेजमेंट सिस्टम', 'ડેટાબેઝ મેનેજમેન્ટ સિસ્ટમ'],
  'courseCn': ['Computer Networks', 'कंप्यूटर नेटवर्क', 'કમ્પ્યુટર નેટવર્ક્સ'],
  'selectedCount': ['{a} of {b} selected', '{b} में से {a} चयनित', '{b} માંથી {a} પસંદ'],
  'dashboardCustomization': ['Dashboard Customization', 'डैशबोर्ड अनुकूलन', 'ડેશબોર્ડ કસ્ટમાઇઝેશન'],
  'cardsPerRow': ['Cards per row', 'प्रति पंक्ति कार्ड', 'દરેક હરોળમાં કાર્ડ'],
  'showModules': ['Show modules on dashboard', 'डैशबोर्ड पर मॉड्यूल दिखाएं', 'ડેશબોર્ડ પર મોડ્યુલ્સ બતાવો'],

  // Navigation
  'dashboard': ['Dashboard', 'डैशबोर्ड', 'ડેશબોર્ડ'],
  'profile': ['Profile', 'प्रोफ़ाइल', 'પ્રોફાઇલ'],
  'enableNotifications': ['Enable notifications', 'सूचनाएं चालू करें', 'સૂચનાઓ ચાલુ કરો'],
  'notificationsOff': ['Notifications are turned off.', 'सूचनाएं बंद हैं।', 'સૂચનાઓ બંધ છે.'],

  // Notes and tasks
  'notes': ['Notes', 'नोट्स', 'નોંધો'],
  'tasks': ['Tasks', 'कार्य', 'કાર્યો'],
  'notesSubtitle': ['Study notes', 'अध्ययन नोट्स', 'અભ્યાસ નોંધો'],
  'tasksSubtitle': ['To-do list', 'करने योग्य कार्य', 'કરવાના કાર્યો'],

  // Notices (REST API)
  'notices': ['Notices', 'नोटिस', 'નોટિસ'],
  'noticesSubtitle': ['Live from the web', 'वेब से लाइव', 'વેબ પરથી લાઇવ'],
  'feedback': ['Feedback', 'प्रतिक्रिया', 'પ્રતિસાદ'],
};
