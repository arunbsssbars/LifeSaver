/// Model representing NDMA Emergency Family Survival ID & Digital Disaster Pass
/// conforming to National Disaster Management Authority (NDMA) family preparedness guidelines.
class EmergencyFamilyPass {
  final String familyHeadName;
  final String bloodGroup;
  final int familyMemberCount;
  final String primaryContactPhone;
  final String secondaryContactPhone;
  final String chronicConditionsOrAllergies;
  final String designatedEvacuationMeetingPoint;
  final String govtIdLastFourDigits;
  final Map<String, bool> survivalKitChecklist;

  const EmergencyFamilyPass({
    required this.familyHeadName,
    required this.bloodGroup,
    required this.familyMemberCount,
    required this.primaryContactPhone,
    required this.secondaryContactPhone,
    required this.chronicConditionsOrAllergies,
    required this.designatedEvacuationMeetingPoint,
    required this.govtIdLastFourDigits,
    required this.survivalKitChecklist,
  });

  /// Default mock profile for instant out-of-the-box readiness
  static EmergencyFamilyPass defaultProfile() {
    return const EmergencyFamilyPass(
      familyHeadName: 'Arun Kumar & Family',
      bloodGroup: 'O+ Positive',
      familyMemberCount: 4,
      primaryContactPhone: '+91 98765 43210',
      secondaryContactPhone: '+91 98111 22334',
      chronicConditionsOrAllergies: 'Asthma inhaler required, Penicillin allergy',
      designatedEvacuationMeetingPoint: 'Sector Community Center & High Ground Ground',
      govtIdLastFourDigits: '8842',
      survivalKitChecklist: {
        '3L Clean Drinking Water / person / day': true,
        'Ready-to-eat dry rations (3-day supply)': true,
        'First Aid Kit & Essential Prescriptions': true,
        'High-beam LED Flashlight & Extra Cells': true,
        'Whistle (Universal 3-blast distress signal)': true,
        'Battery Power Bank & Charging Cables': false,
        'Laminated copies of Govt IDs & Insurance': true,
        'Waterproof matches / Lighter / Multi-tool': false,
      },
    );
  }

  /// Calculates NDMA 72-Hour Kit readiness percentage
  double get kitReadinessPercent {
    if (survivalKitChecklist.isEmpty) return 0.0;
    final packedCount = survivalKitChecklist.values.where((v) => v).length;
    return (packedCount / survivalKitChecklist.length) * 100;
  }

  /// Generates standardized NDMA Relief Camp Check-in Manifest
  String generateReliefCampManifest() {
    return '--- NDMA DISASTER SURVIVAL PASS ---\n'
        'Head of Family: $familyHeadName\n'
        'Members: $familyMemberCount | Blood: $bloodGroup\n'
        'Emergency Contacts: $primaryContactPhone / $secondaryContactPhone\n'
        'Medical Alert: $chronicConditionsOrAllergies\n'
        'Aadhaar/ID Ref: XXXX-XXXX-$govtIdLastFourDigits\n'
        'Meeting Point: $designatedEvacuationMeetingPoint\n'
        '72-Hr Kit Preparedness: ${kitReadinessPercent.toStringAsFixed(0)}%';
  }

  /// Generates broadcast distress text
  String generateDistressBroadcast({
    required double latitude,
    required double longitude,
    required String regionName,
  }) {
    return '🚨 EMERGENCY DISTRESS BROADCAST (NDMA/ERSS 112) 🚨\n'
        'Location: $regionName (GPS: ${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)})\n'
        'Family: $familyHeadName ($familyMemberCount persons)\n'
        'Blood Group: $bloodGroup\n'
        'Critical Medical Need: $chronicConditionsOrAllergies\n'
        'Contact: $primaryContactPhone\n'
        'Maps: https://maps.google.com/?q=$latitude,$longitude';
  }
}

/// Multi-lingual disaster triage phrase for first responder communication
class DisasterPhrase {
  final String category;
  final String english;
  final String hindi;
  final String bengali;
  final String tamil;
  final String telugu;
  final String marathi;
  final String nepali;

  const DisasterPhrase({
    required this.category,
    required this.english,
    required this.hindi,
    required this.bengali,
    required this.tamil,
    required this.telugu,
    required this.marathi,
    required this.nepali,
  });

  String getForLanguage(String languageCode) {
    switch (languageCode.toLowerCase()) {
      case 'hi':
        return hindi;
      case 'bn':
        return bengali;
      case 'ta':
        return tamil;
      case 'te':
        return telugu;
      case 'mr':
        return marathi;
      case 'ne':
        return nepali;
      case 'en':
      default:
        return english;
    }
  }

  static const List<DisasterPhrase> triagePhrases = [
    DisasterPhrase(
      category: 'Immediate Rescue',
      english: 'We are trapped! Please rescue us immediately.',
      hindi: 'हम फंसे हुए हैं! कृपया हमें तुरंत बचाएं।',
      bengali: 'আমরা আটকে পড়েছি! দয়া করে আমাদের অবিলম্বে উদ্ধার করুন।',
      tamil: 'நாங்கள் சிக்கியுள்ளோம்! எங்களை உடனே காப்பாற்றுங்கள்.',
      telugu: 'మేము చిక్కుకుపోయాము! దయచేసి వెంటనే మమ్మల్ని రక్షించండి.',
      marathi: 'आम्ही अडकलो आहोत! कृपया आमची त्वरित सुटका करा.',
      nepali: 'हामी फसेका छौं! कृपया हामीलाई तुरुन्त उद्धार गर्नुहोस्।',
    ),
    DisasterPhrase(
      category: 'Medical Emergency',
      english: 'Someone is critically injured and needs emergency medical aid.',
      hindi: 'कोई गंभीर रूप से घायल है और उसे आपातकालीन चिकित्सा सहायता चाहिए।',
      bengali: 'কেউ গুরুতর আহত এবং জরুরি চিকিৎসা সহায়তা প্রয়োজন।',
      tamil: 'ஒருவர் பலத்த காயமடைந்துள்ளார், அவசர மருத்துவ உதவி தேவை.',
      telugu: 'ఒకరు తీవ్రంగా గాయపడ్డారు, అత్యవసర వైద్య సహాయం కావాలి.',
      marathi: 'कोणीतरी गंभीर जखमी आहे आणि तातडीने वैद्यकीय मदतीची गरज आहे.',
      nepali: 'कोही गम्भीर घाइते छ र आपतकालीन उपचार चाहिन्छ।',
    ),
    DisasterPhrase(
      category: 'Vulnerable Persons',
      english: 'We have infants, pregnant women, or elderly people with us.',
      hindi: 'हमारे साथ नवजात शिशु, गर्भवती महिलाएं या बुजुर्ग हैं।',
      bengali: 'আমাদের সাথে শিশু, গর্ভবতী মহিলা বা বৃদ্ধ মানুষ আছেন।',
      tamil: 'எங்களுடன் கைக்குழந்தைகள், கர்ப்பிணிகள் அல்லது முதியவர்கள் உள்ளனர்.',
      telugu: 'మాతో పసిబిడ్డలు, గర్భిణీ స్త్రీలు లేదా వృద్ధులు ఉన్నారు.',
      marathi: 'आमच्यासोबत लहान मुले, गरोदर महिला किंवा वृद्ध आहेत.',
      nepali: 'हामीसँग शिशु, गर्भवती महिला वा वृद्ध व्यक्तिहरू छन्।',
    ),
    DisasterPhrase(
      category: 'Life Supplies',
      english: 'We urgently need drinking water and food rations.',
      hindi: 'हमें तुरंत पीने का पानी और खाने की सामग्री चाहिए।',
      bengali: 'আমাদের জরুরিভাবে পানীয় জল এবং শুকনো খাবার প্রয়োজন।',
      tamil: 'எங்களுக்கு உடனடியாக குடிநீரும் உணவுப் பொருட்களும் தேவை.',
      telugu: 'మాకు తక్షణం తాగునీరు మరియు ఆహార పదార్థాలు అవసరం.',
      marathi: 'आम्हाला पिण्याचे पाणी आणि अन्नधान्याची तातडीने गरज आहे.',
      nepali: 'हामीलाई पिउने पानी र खानाको आपतकालीन आवश्यकता छ।',
    ),
  ];
}
