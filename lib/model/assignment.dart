class Assignment {
  final int num;
  final String instructions;
  final List<Question> questions;

  const Assignment(this.num, this.instructions, this.questions);

  bool get enabled => questions.isNotEmpty;
}

const assignments = [
  Assignment(
    1, "Read each question carefully and mark the one most correct answer on answer sheet.",
    [
      MultipleChoiceQuestion(
        number: 1,
        question: "In clarifying the observation 8C/K with a client, which of the following is correct?",
        options: {
          "A": "The C/K designation means the mucus is “foggy” in color like wax paper.",
          "B": "The teacher must double check the observation to make sure that the K represents crystal clear.",
          "C": "There is no need for clarification.",
          "D": "All of the above",
          "E": "None of the above",
        },
      ),
      MultipleChoiceQuestion(
        number: 2,
        question: "In clarifying the observation 4Kx4 with a client, which of the following is correct?",
        options: {
          "A": "You would wish to question the recording of K.",
          "B": "It is true that people record, incorrectly, the K in this observation because there is no color associated with the shiny that is observed in this observation.",
          "C": "The “x4” should read “AD” and the client and the chart should be so corrected.",
          "D": "All of the above",
          "E": "None of the above",
        },
      ),
      MultipleChoiceQuestion(
        number: 3,
        question: "In clarifying the observation 10G with a client, which of the following is correct?",
        options: {
          "A": "The client obviously has a cervical inflammation.",
          "B": "This description lacks a color, therefore it is incomplete.",
          "C": "The “10” does not need to be clarified because it means stretchy.",
          "D": "All of the above",
          "E": "None of the above",
        },
      ),
      MultipleChoiceQuestion(
        number: 4,
        question: "In clarifying the observation 8-10Cx2 with a client, which of the following is correct?",
        options: {
          "A": "The mucus is obviously stretching somewhere between 3⁄4 and 1 inch.",
          "B": "In this description, the client is hesitating in making a definitive decision on the observation.",
          "C": "If lubrication is absent, the client should record it as “NL” – not lubricative.",
          "D": "All of the above",
          "E": "None of the above",
        },
      ),
      MultipleChoiceQuestion(
        number: 5,
        question: "In the Vaginal Discharge Recording System, the description of “sticky, cloudy, seen once” would be recorded as:",
        options: {
          "A": "6CLx1",
          "B": "8Cx1",
          "C": "6PCx1",
          "D": "6Cx1",
          "E": "4CAD",
        },
      ),
      MultipleChoiceQuestion(
        number: 6,
        question: "Which of the following are considered Peak-type mucus?",
        options: {
          "A": "8C",
          "B": "6PC",
          "C": "10DL",
          "D": "All of the above",
          "E": "None of the above",
        },
      ),
      MultipleChoiceQuestion(
        number: 7,
        question: "Which of the following are considered non-Peak type mucus?",
        options: {
          "A": "10SL",
          "B": "2",
          "C": "6PC",
          "D": "All of the above",
          "E": "None of the above",
        },
      ),
      MultipleChoiceQuestion(
        number: 8,
        question: "An important general principle or principles which apply to chart correcting a “6C” observation is (are):",
        options: {
          "A": "Assess whether or not the client is really stretching the mucus ½-¾ inch or not (as her “6C” description indicates).",
          "B": "Compare her observation with the “PC” observation in the Picture Dictionary in order to distinguish whether the observation is a “sticky, cloudy” cervical mucus discharge or a “sticky, pasty, cloudy” vaginal discharge. ",
          "C": "Assume that the client is correct in her observation of cloudiness.",
          "D": "All of the above",
          "E": "None of the above",
        },
      ),
      MultipleChoiceQuestion(
        number: 9,
        question: "The use of a plain, green stamp during the post-Peak phase of the cycle (after the third day) is legitimate in which of the following situations?",
        options: {
          "A": "A “6Cx1” observation in the second cycle of charting",
          "B": "A ”VL-6PCx2” observation in the third cycle of charting",
          "C": "A “6PCAD” observation in the fifth cycle of charting",
          "D": "All of the above",
          "E": "None of the above",
        },
      ),
      MultipleChoiceQuestion(
        number: 10,
        question: "An important principle or principles in reading a CREIGHTON MODEL FertilityCare™ System chart include:",
        options: {
          "A": "Read each description, day by day.",
          "B": "Read the proper placement of stamps, day by day.",
          "C": "Develop a consistent pattern, which is concise but complete.",
          "D": "All of the above",
          "E": "None of the above",
        },
      ),
    ],
  ),
  Assignment(2, "TODO", []),
  Assignment(3, "TODO", []),
];

abstract class Question {
  int get number;
  String get question;

  const Question();
}

class MultipleChoiceQuestion extends Question {
  @override
  final int number;
  @override
  final String question;

  final Map<String, String> options;

  const MultipleChoiceQuestion({required this.number, required this.question, required this.options});
}