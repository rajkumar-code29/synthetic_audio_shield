Synthetic Audio Shield

1. Summary
   This project aims for the development of a "Digital Guardian", a comprehensive software ecosystem designed to protect vulnerable demographics, particularly the elderly, individuals with early-stage cognitive decline, and visually impaired users, from telecommunications fraud.
   The rise of AI-generated synthetic voices (voice cloning) and highly targeted social engineering scripts presents a critical security and loss of finances to populations least equipped to identify them.
   Paired with a highly accessible, assistive mobile application, this project addresses the critical intersection of cybersecurity, mental health support, and digital accessibility.
   Features:
1. SAS - synthetic audio shield
2. Warn Spam calls - Identify and store numbers reported by users and warn users if its likely a spam
3. Identify Scam Script using keywords used in scam calls - warn users to not divulge sensitive information

1. Problem Statement & Rationale
   2.1. The Threat Matrix: Synthetic Voice & Cognitive Vulnerability
   The democratisation of generative artificial intelligence (GenAI) has lowered the technical barrier for malicious actors to execute high-stakes telecommunications fraud. Bad actors can now clone a relative’s or Friend’s voice using as little as three seconds of leaked audio from social media. When combined with aggressive social engineering scripts (e.g., fake banking emergencies, urgent kidnapping scams), the cognitive load placed on a call recipient is immense. For elderly individuals or those suffering from cognitive impairments, the psychological defense mechanisms required to critically evaluate a digital audio stream are severely compromised. This leads directly to financial ruin and severe, long-term digital anxiety.

2.2. The Accessibility Gap in Existing Solutions
Current mobile security applications are fundamentally flawed when protecting vulnerable groups:
• Visual Reliance: Existing spam-blocking tools rely almost entirely on visual notification toast messages or colored banners on the screen. For partially sighted or blind users, these indicators are completely useless.
• Cognitive Overload: Typical security applications present users with complex configurations, log menus, and technical terminology (e.g., "spoofed VoIP gateway"). A user with cognitive decline cannot navigate these interfaces during a high-stress, real-time event.
2.3. The Technical Stonewall (Mobile OS Security Architecture)
From an engineering perspective, developers attempting to build local mobile applications to solve this problem run into a deliberate hardware and software barrier. Modern operating systems like Apple iOS and Google Android strictly sandbox the cellular telecommunications pipeline.
To comply with international wiretapping and privacy regulations, the OS isolates the VOICE_DOWNLINK stream (the caller's voice) from the application layer. Third-party apps physically cannot access the call audio to run digital signal processing or machine learning algorithms.

3. Proposed Solution & Bifurcated Architecture
   To solve the technical restrictions of the device while answering the accessibility needs of the user, this project implements a bifurcated architecture: an Upstream AI Telecom Proxy Engine and a downstream Assistive Mobile Guardian Interface.
   [Incoming Call] ---> [SIP Trunk / Telecom Proxy Server] ---> [User's Mobile Device] | v [Python AI Engine] (STFT -> Spectrogram -> Classifier)
   3.1. The "Brain"
   Instead of fighting the operating system at the endpoint device, the communication stream is intercepted at the network layer (Same as RogerVoice application)
   • The SIP Bridge: The system establishes a middleware proxy utilising Session Initiation Protocol (SIP) trunking and WebRTC audio pipelines.
   • Digital Signal Processing (DSP): As binary audio packets pass through the proxy server, they are streamed in real-time to a Python backend (Pytorch). The audio waveform is processed using a Short-Time Fourier Transform (STFT) algorithm to map frequency changes over time, converting the raw audio bytes into a Log-Mel Spectrogram.
   • Machine Learning Classification: The extracted mathematical features—specifically Mel-frequency Cepstral Coefficients (MFCCs)—are fed into a trained binary classifier (e.g., a Support Vector Machine or Convolutional Neural Network). The model checks for the synthetic artifacts, unnatural phase shifts, and acoustic anomalies left behind by AI voice-cloning engines, evaluating the call in under 500 milliseconds.
   3.2. The "Guardian"
   The mobile application built for this project does not intercept the audio; instead, it acts as the primary assistive user interface and safety intervention point.
   • Haptic and Acoustic Interventions: When the upstream engine flags a call as highly probable fraud, it sends a high-priority push notification to the app via WebSockets. The mobile application instantly bypasses standard visual queues, triggering distinct, low-frequency haptic vibration patterns (pulses) and clear, calming text-to-speech audio alerts (e.g., "Please take a breath. This caller's identity cannot be verified. We recommend hanging up.") to fully support partially sighted users.
   • Cognitive Simplification UI: The frontend is engineered using a high-contrast, distraction-free design language. Complex cybersecurity threat metrics are completely stripped away, replaced by large, color-coded safety states (e.g., Safe / Verifying / Warning).
   • Mental Health Feedback Loop: To address the emotional toll of fraud, the application features an event-driven logging mechanism. After a flagged call, the app prompts the user with an incredibly simple, accessible voice-input interface to record how they are feeling. This data monitors digital anxiety trends over time and can be securely shared with authorized family members or caregivers via a secure dashboard.
