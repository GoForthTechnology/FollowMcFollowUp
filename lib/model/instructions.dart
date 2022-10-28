class Instructions {
  final List<Instruction> instruction;

  Instructions(this.instruction);
}

enum Instruction {
  a,b, c,
  d1, d2, d3, d4, d5, d6,
  e1, e2, e3, e4, e5, e6, e7,
  f, g1, g2, g3, h,
  i1, i2, i3, i4,
  j, k1, k2, k3, k4, k5, k6,
  l, m, n, o,
  ys1c // Magic instructions from Book 2, page 85
  ;

  String get description {
    switch (this) {
      case Instruction.a:
        return "Always keep to the observation routine.";
      case Instruction.b:
        return "Chart at the end of your day, every day, and record the most fertile sign of the day.";
      case Instruction.c:
        return "Avoid genital contact";
      case Instruction.d1:
        return "The menstrual flow";
      case Instruction.d2:
        return "From the beginning of mucus until 3 full days post peak.";
      case Instruction.d3:
        return "1 or 2 days of non-Peak mucus pre-Peak";
      case Instruction.d4:
        return "3 or more days of non-Peak mucus pre-Peak -- plus count of 3";
      case Instruction.d5:
        return "Any single day of Peak mucus -- plus count 3";
      case Instruction.d6:
        return "Any unusual bleeding -- plus count 3";
      case Instruction.e1:
        return "Dry days pre-Peak -- end of the day, alternate days";
      case Instruction.e2:
        return "Dry days pre-Peak -- end of the day, every day";
      case Instruction.e3:
        return "4th day post-Peak -- always end of the day";
      case Instruction.e4:
        return "Dry days post-Peak (after 4th day) -- end of the day, alternate days";
      case Instruction.e5:
        return "Dry days post-Peak (after 4th day) -- end of the day, every day";
      case Instruction.e6:
        return "Dry days post-Peak (after 4th day) -- any time of the day";
      case Instruction.e7:
        return "Dry days on L, VL or B days of bleeding at end of the menstrual flow -- end of the day";
      case Instruction.f:
        return "Seminal fluid instruction";
      case Instruction.g1:
        return "On P+3 ask double peak questions";
      case Instruction.g2:
        return "If post-Peak phase is greater than 16 days in duration and system used properly to avoid pregnancy, anticipate missed period form of double peak";
      case Instruction.g3:
        return "When anticipating double Peak, keep to the end of infertile days and continue good observations";
      case Instruction.h:
        return "When in doubt, consider yourself of peak fertility and count 3";
      case Instruction.i1:
        return "Avoid genital contact until good mucus is present";
      case Instruction.i2:
        return "Use days of greatest quantity and quality and first two days afterward";
      case Instruction.i3:
        return "Record the amount of stretch of the mucus (1\", 2\", 3\", etc.)";
      case Instruction.i4:
        return "Record abdominal pain (AP), right abdominal pain (RAP), and left abdominal pain (LAP)";
      case Instruction.j:
        return "Essential samness quesiton -- Is today essentially the same as yesterday? -- yes or no";
      case Instruction.k1:
        return "Pre-Peak -- end of the day, alternate days";
      case Instruction.k2:
        return "Post-Peak (after the fourth day) -- end of the day, alternate days";
      case Instruction.k3:
        return "Post-Peak (after the fourth day) -- end of the day, every day";
      case Instruction.k4:
        return "Post-Peak (after the fourth day) -- any time of day";
      case Instruction.k5:
        return "Discontinue use when period starts";
      case Instruction.k6:
        return "Discontinue pre-Peak Y.S. in regular cycles when mucus cycle < 9 days";
      case Instruction.l:
        return "If totally breastfeeding, first 56 days after birth of baby are infertile.";
      case Instruction.m:
        return "End of day instructions apply through the first normal menstrual cycle";
      case Instruction.n:
        return "End of day instructions apply through the first normal menstrual cycle.";
      case Instruction.o:
        return "Continue charting for the duration of the pregnancy";
      case Instruction.ys1c:
        return "Any single day of change -- plus count of three";
    }
  }
}