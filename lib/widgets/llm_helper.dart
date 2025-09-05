class LLMHelper {
  // Mock LLM responses
  static String getResponse(String question) {
    question = question.toLowerCase();
    if (question.contains("documents")) {
      return "You need Aadhaar, PAN, or Passport to complete KYC.";
    } else if (question.contains("pan")) {
      return "PAN is required to verify your identity and for taxation purposes.";
    } else if (question.contains("digilocker")) {
      return "Digilocker allows you to fetch government documents digitally, securely.";
    } else if (question.contains("face")) {
      return "Ensure your face is inside the frame and blink to verify liveness.";
    } else {
      return "Please contact support for more help.";
    }
  }
}
