import '../models/case_model.dart';
import '../models/clue_model.dart';
import '../models/suspect_model.dart';
import '../models/question_model.dart';

// 所有遊戲資料都寫在這裡，簡單明瞭！

// 案件資料
final List<Case> allCases = [
  Case(
    id: 1,
    title: '第一章：神秘的訪客',
    description: '深夜，豪宅中發生了神秘事件...\n\n這是完整可玩的章節，包含訊問、線索和推理！',
    imageUrl: 'assets/images/case1.png',
  ),
  Case(
    id: 2,
    title: '第二章：真相大白',
    description: '此章節尚未開放，留給學生自己擴充練習！',
    imageUrl: 'assets/images/case2.png',
  ),
];

// 線索資料（全部可見）
final List<Clue> allClues = [
  Clue(
    id: 'clue_1',
    chapterId: 1,
    title: '破碎的玻璃杯',
    description: '在現場發現的破碎玻璃杯，上面有指紋痕跡。',
    imageUrl: 'assets/images/clue1.png',
    time: '23:45',
    credibility: '高',
    isUnlocked: true,
  ),
  Clue(
    id: 'clue_2',
    chapterId: 1,
    title: '神秘的字條',
    description: '密室中發現的字條，上面寫著「午夜見」。',
    imageUrl: 'assets/images/clue2.png',
    time: '00:00',
    credibility: '中',
    isUnlocked: true,
  ),
  Clue(
    id: 'clue_3',
    chapterId: 1,
    title: '監視器畫面',
    description: '走廊監視器拍到的可疑人影。',
    imageUrl: 'assets/images/clue3.png',
    time: '23:30',
    credibility: '高',
    isUnlocked: true,
  ),
];

// 嫌疑人資料
final List<Suspect> allSuspects = [
  Suspect(
    id: 'suspect_1',
    name: '張先生',
    age: 35,
    occupation: '商人',
    alibi: '聲稱案發時在辦公室加班',
    imageUrl: 'assets/images/suspect1.png',
    gender: '男',
  ),
  Suspect(
    id: 'suspect_2',
    name: '李先生',
    age: 42,
    occupation: '律師',
    alibi: '聲稱案發時在家休息',
    imageUrl: 'assets/images/suspect2.png',
    gender: '男',
  ),
];

// 問題資料
final List<Question> allQuestions = [
  Question(
    id: 'q1',
    suspectId: 'suspect_1',
    question: '案發當晚你在哪裡？',
    answer: '我在辦公室加班到很晚，大約凌晨一點才離開。',
    unlocksClue: '',
  ),
  Question(
    id: 'q2',
    suspectId: 'suspect_1',
    question: '你認識受害者嗎？',
    answer: '認識，我們是生意上的合作夥伴，但最近有些分歧。',
    unlocksClue: '',
  ),
  Question(
    id: 'q3',
    suspectId: 'suspect_2',
    question: '你和受害者的關係如何？',
    answer: '我是他的律師，處理過很多法律事務。',
    unlocksClue: '',
  ),
  Question(
    id: 'q4',
    suspectId: 'suspect_2',
    question: '案發當晚你在做什麼？',
    answer: '我在家看書，沒有外出。我太太可以作證。',
    unlocksClue: '',
  ),
];
