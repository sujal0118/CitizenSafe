<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>File a Complaint</title>
    <style>
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            display: flex;
            gap: 30px;
        }
        .main-content {
            flex: 1;
        }
        .side-content {
            width: 300px;
            flex-shrink: 0;
        }
        .header {
            background-color: #2d3748;
            color: white;
            padding: 15px 20px;
            margin: -20px -20px 20px -20px;
        }
        .header h1 {
            margin: 0;
            font-size: 24px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-label {
            display: block;
            margin-bottom: 5px;
            color: #4a5568;
        }
        .form-control {
            width: 100%;
            padding: 8px;
            border: 1px solid #e2e8f0;
            border-radius: 4px;
            background-color: #f8f9fa;
            box-sizing: border-box;
        }
        .voice-controls {
            display: flex;
            gap: 10px;
            margin-bottom: 10px;
        }
        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .btn-record {
            background-color: #1dc9b7;
            color: white;
        }
        .btn-speech {
            background-color: #2d3748;
            color: white;
        }
        .btn-dictate {
            background-color: #4CAF50;
            color: white;
        }
        .btn-dictate.active {
            background-color: #dc3545;
        }
        .speech-status {
            margin-top: 5px;
            font-size: 0.9em;
            color: #666;
        }
        .btn-back {
            background-color: #6c757d;
            color: white;
            text-decoration: none;
            display: inline-block;
            margin-bottom: 20px;
        }
        .guidelines {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 4px;
        }
        .voice-features {
            background-color: #e6f7f5;
            padding: 20px;
            border-radius: 4px;
            margin-top: 20px;
        }
        .guidelines ul, .voice-features ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        .guidelines li, .voice-features li {
            margin-bottom: 10px;
            position: relative;
            padding-left: 15px;
        }
        .guidelines li:before, .voice-features li:before {
            content: "•";
            position: absolute;
            left: 0;
        }
        h2 {
            font-size: 1.5em;
            margin-bottom: 20px;
            color: #2d3748;
        }
        h3 {
            color: #2d3748;
            margin-bottom: 15px;
        }
        .evidence-preview {
            margin-top: 10px;
            padding: 10px;
            background-color: #f8f9fa;
            border-radius: 4px;
            display: none;
        }
        .evidence-preview.active {
            display: block;
        }
        .audio-controls {
            width: 100%;
            margin: 10px 0;
        }
        .file-preview {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 8px;
            background-color: #e9ecef;
            border-radius: 4px;
            margin-top: 5px;
        }
        .file-preview i {
            color: #6c757d;
        }
        .error-message {
            color: #dc3545;
            font-size: 0.9em;
            margin-top: 5px;
            display: none;
        }
        .error-message.active {
            display: block;
        }
        .file-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 8px;
            background-color: #e9ecef;
            border-radius: 4px;
            margin-top: 5px;
        }
        .file-info {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .file-size {
            color: #6c757d;
            font-size: 0.9em;
        }
        .remove-file {
            background: none;
            border: none;
            color: #dc3545;
            cursor: pointer;
            padding: 4px 8px;
            font-size: 1.2em;
        }
        .remove-file:hover {
            background-color: #dc35451a;
            border-radius: 4px;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>File a Complaint</h1>
    </div>
    
    <div class="container">
        <div class="main-content">
            <a href="index.jsp" class="btn btn-back">← Back</a>
            
            <h2>Complaint Details</h2>
            <form action="SubmitComplaint" method="POST" enctype="multipart/form-data" id="complaintForm">
                <h3>Personal Information</h3>
                
                <div class="form-group">
                    <label class="form-label">Full Name*</label>
                    <input type="text" name="fullName" class="form-control" required>
                </div>

                <div class="form-group">
                    <label class="form-label">Contact Number*</label>
                    <input type="tel" name="contactNumber" class="form-control" 
                           pattern="[\+]?[0-9\s\-\(\)]+" 
                           placeholder="0000000000" required>
                </div>

                <h3>Incident Details</h3>
                
                <div class="form-group">
                    <label class="form-label">Type of Fraud*</label>
                    <select name="fraudType" class="form-control" required>
                        <option value="">Select Type ▼</option>
                        <option value="phone">Phone Fraud</option>
                        <option value="email">Email Fraud</option>
                        <option value="website">Website Fraud</option>
                        <option value="identity">Identity Theft</option>
                        <option value="other">Other</option>
                    </select>
                </div>

                <div class="form-group">
                    <label class="form-label">Date of Incident*</label>
                    <input type="date" name="incidentDate" class="form-control" required>
                </div>

                <div class="form-group">
                    <label class="form-label">Description*</label>
                    <div class="voice-controls">
                        <button type="button" class="btn btn-speech">
                            <span>Text to Speech</span>
                        </button>
                        <button type="button" class="btn btn-dictate">
                            <span>Start Dictation</span>
                        </button>
                    </div>
                    <div class="speech-status"></div>
                    <textarea name="description" class="form-control" rows="5" required></textarea>
                </div>
                    <div class="form-group">
        <label class="form-label">Nearest Police Station*</label>
        <select name="policeStation" class="form-control" required>
            <option value="">Select Police Station ▼</option>
            <option value="Shivajinagar Police Station">Shivajinagar Police Station</option>
            <option value="Bund Garden Police Station">Bund Garden Police Station</option>
            <option value="Deccan Gymkhana Police Station">Deccan Gymkhana Police Station</option>
            <option value="Kothrud Police Station">Kothrud Police Station</option>
            <option value="Khadki Police Station">Khadki Police Station</option>
            <option value="Hadapsar Police Station">Hadapsar Police Station</option>
            <option value="Swargate Police Station">Swargate Police Station</option>
            <option value="Wanowrie Police Station">Wanowrie Police Station</option>
            <option value="Yerwada Police Station">Yerwada Police Station</option>
            <option value="Chaturshringi Police Station">Chaturshringi Police Station</option>
            <option value="Warje Malwadi Police Station">Warje Malwadi Police Station</option>
            <option value="Sinhagad Road Police Station">Sinhagad Road Police Station</option>
            <option value="Pimpri Police Station">Pimpri Police Station</option>
            <option value="Chinchwad Police Station">Chinchwad Police Station</option>
        </select>
    </div>

                <h3>Evidence</h3>
                
                <!-- Updated Audio Recording Section -->
                <div class="form-group">
                    <label class="form-label">Record Audio Statement</label>
                    <div class="voice-controls">
                        <button type="button" class="btn btn-record" id="recordButton">
                            Start Recording
                        </button>
                        <span id="recordingStatus" style="margin-left: 10px;"></span>
                    </div>
                    
                    <!-- Audio Preview Section -->
                    <div class="evidence-preview" id="audioPreview">
                        <audio controls class="audio-controls" id="audioPlayback"></audio>
                        <input type="hidden" id="audioBlobData" name="audioBlobData">
                    </div>
                </div>

                <!-- File Upload Section -->
                <div class="form-group">
                    <label class="form-label">Additional Evidence (Multiple files allowed)</label>
                    <input type="file" name="evidence[]" id="evidenceFile" class="form-control" 
                           accept="image/*,.pdf,.doc,.docx,audio/*"
                           title="Upload files (Max 10MB each)"
                           multiple>
                    
                    <!-- File Preview Section -->
                    <div class="evidence-preview" id="filePreview">
                        <div id="fileList"></div>
                    </div>
                </div>

                <div class="error-message" id="evidenceError">
                    Please provide at least one form of evidence (recorded audio or file upload)
                </div>

                <button type="submit" class="btn btn-record" onclick="return confirmSubmission()" style="width: 100%;">Submit Complaint</button>
            </form>
        </div>

        <div class="side-content">
            <div class="guidelines">
                <h2>Guidelines</h2>
                <ul>
                    <li>Provide accurate details</li>
                    <li>Include contact info</li>
                    <li>Describe incident clearly</li>
                    <li>Attach evidence if any</li>
                </ul>
            </div>

            <div class="voice-features">
                <h2>Voice Features:</h2>
                <ul>
                    <li>Click <span>🎙️</span> to record</li>
                    <li>Speak clearly</li>
                    <li>Review before submit</li>
                    <li>Edit text if needed</li>
                </ul>
            </div>
        </div>
    </div>

    <script>
    document.addEventListener('DOMContentLoaded', function() {
        // Global variables
        let mediaRecorder;
        let audioChunks = [];
        let isRecording = false;
        let recognition;
        let isListening = false;
        let uploadedFiles = new Set();
        
        // Browser support checks
        const isSpeechRecognitionSupported = 'SpeechRecognition' in window || 'webkitSpeechRecognition' in window;
        const isSpeechSynthesisSupported = 'speechSynthesis' in window;
        
        // DOM Elements
        const recordButton = document.getElementById('recordButton');
        const recordingStatus = document.getElementById('recordingStatus');
        const audioPreview = document.getElementById('audioPreview');
        const audioPlayback = document.getElementById('audioPlayback');
        const fileInput = document.getElementById('evidenceFile');
        const filePreview = document.getElementById('filePreview');
        const fileList = document.getElementById('fileList');
        const evidenceError = document.getElementById('evidenceError');
        const form = document.getElementById('complaintForm');
        const speechButton = document.querySelector('.btn-speech');
        const dictateButton = document.querySelector('.btn-dictate');
        const speechStatus = document.querySelector('.speech-status');
        const descriptionTextarea = document.querySelector('textarea[name="description"]');

        // File handling functions
        function formatFileSize(bytes) {
            if (bytes === 0) return '0 Bytes';
            const k = 1024;
            const sizes = ['Bytes', 'KB', 'MB', 'GB'];
            const i = Math.floor(Math.log(bytes) / Math.log(k));
            return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
        }

        function createFileItem(file) {
            const fileItem = document.createElement('div');
            fileItem.className = 'file-item';
            
            const fileInfo = document.createElement('div');
            fileInfo.className = 'file-info';
            
            const icon = document.createElement('span');
            if (file.type.startsWith('image/')) {
                icon.textContent = '🖼️';
            } else if (file.type.startsWith('audio/')) {
                icon.textContent = '🎵';
            } else if (file.type.includes('pdf')) {
                icon.textContent = '📄';
            } else if (file.type.includes('doc')) {
                icon.textContent = '📝';
            } else {
                icon.textContent = '📎';
            }
            
            const fileName = document.createElement('span');
            fileName.textContent = file.name;
            
            const fileSize = document.createElement('span');
            fileSize.className = 'file-size';
            fileSize.textContent = formatFileSize(file.size);
            
            const removeButton = document.createElement('button');
            removeButton.className = 'remove-file';
            removeButton.textContent = '×';
            removeButton.title = 'Remove file';
            removeButton.onclick = function(e) {
                e.preventDefault();
                uploadedFiles.delete(file);
                fileItem.remove();
                updateFilePreviewVisibility();
                
                const dt = new DataTransfer();
                uploadedFiles.forEach(f => dt.items.add(f));
                fileInput.files = dt.files;
            };
            
            fileInfo.appendChild(icon);
            fileInfo.appendChild(fileName);
            fileInfo.appendChild(fileSize);
            fileItem.appendChild(fileInfo);
            fileItem.appendChild(removeButton);
            
            return fileItem;
        }

        function updateFilePreviewVisibility() {
            if (uploadedFiles.size > 0) {
                filePreview.classList.add('active');
            } else {
                filePreview.classList.remove('active');
            }
        }

        // Recording Functions
        async function setupRecording() {
            try {
                const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
                mediaRecorder = new MediaRecorder(stream);
                
                mediaRecorder.ondataavailable = (event) => {
                    audioChunks.push(event.data);
                };

                mediaRecorder.onstop = () => {
                    const audioBlob = new Blob(audioChunks, { type: 'audio/webm' });
                    const audioUrl = URL.createObjectURL(audioBlob);
                    audioPlayback.src = audioUrl;
                    audioPreview.classList.add('active');
                    
                    // Convert Blob to Base64 and store in hidden input
                    const reader = new FileReader();
                    reader.readAsDataURL(audioBlob);
                    reader.onloadend = () => {
                        document.getElementById('audioBlobData').value = reader.result;
                    };
                };
            } catch (err) {
                console.error('Error accessing microphone:', err);
                alert('Unable to access microphone. Please check your permissions.');
            }
        }
                // Speech Recognition Functions
        function initializeSpeechRecognition() {
        
        if (!recognition && isSpeechRecognitionSupported) {
                const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
                recognition = new SpeechRecognition();
                recognition.continuous = true;
                recognition.interimResults = true;
                recognition.lang = 'en-US';

                recognition.onstart = () => {
                    speechStatus.textContent = 'Listening... Speak clearly into your microphone';
                    dictateButton.textContent = 'Stop Dictation';
                    dictateButton.classList.add('active');
                    isListening = true;
                };

                recognition.onend = () => {
                    speechStatus.textContent = 'Dictation stopped';
                    dictateButton.textContent = 'Start Dictation';
                    dictateButton.classList.remove('active');
                    isListening = false;
                };

                recognition.onerror = (event) => {
                    console.error('Speech Recognition Error:', event.error);
                    speechStatus.textContent = `Error: ${event.error}. Please try again.`;
                    stopDictation();
                };

                recognition.onresult = (event) => {
                    let interimTranscript = '';
                    let finalTranscript = '';

                    for (let i = event.resultIndex; i < event.results.length; i++) {
                        const transcript = event.results[i][0].transcript;
                        if (event.results[i].isFinal) {
                            finalTranscript += transcript + ' ';
                        } else {
                            interimTranscript += transcript;
                        }
                    }

                    if (finalTranscript) {
                        const cursorPosition = descriptionTextarea.selectionStart;
                        const textBeforeCursor = descriptionTextarea.value.substring(0, cursorPosition);
                        const textAfterCursor = descriptionTextarea.value.substring(cursorPosition);
                        
                        descriptionTextarea.value = textBeforeCursor + finalTranscript + textAfterCursor;
                        descriptionTextarea.selectionStart = cursorPosition + finalTranscript.length;
                        descriptionTextarea.selectionEnd = cursorPosition + finalTranscript.length;
                    }

                    if (interimTranscript) {
                        speechStatus.textContent = `Hearing: ${interimTranscript}`;
                    }
                };
            }
        }

        function textToSpeech() {
            if (!isSpeechSynthesisSupported) {
                alert('Text-to-speech is not supported in your browser');
                return;
            }

            const text = descriptionTextarea.value.trim();
            if (text) {
                const utterance = new SpeechSynthesisUtterance(text);
                window.speechSynthesis.speak(utterance);
            } else {
                alert('Please enter some text to read.');
            }
        }

        function toggleDictation() {
            if (!isSpeechRecognitionSupported) {
                alert('Speech recognition is not supported in your browser');
                return;
            }

            if (!isListening) {
                initializeSpeechRecognition();
                recognition.start();
            } else {
                recognition.stop();
            }
        }

        // Event Listeners
        recordButton.addEventListener('click', async () => {
            if (!mediaRecorder) {
                await setupRecording();
            }
            
            if (!isRecording) {
                audioChunks = [];
                mediaRecorder.start();
                isRecording = true;
                recordButton.textContent = 'Stop Recording';
                recordButton.style.backgroundColor = '#dc3545';
                recordingStatus.textContent = 'Recording...';
            } else {
                mediaRecorder.stop();
                isRecording = false;
                recordButton.textContent = 'Start Recording';
                recordButton.style.backgroundColor = '#1dc9b7';
                recordingStatus.textContent = 'Recording finished';
            }
        });

        fileInput.addEventListener('change', (e) => {
            const files = Array.from(e.target.files);
            files.forEach(file => {
                if (file.size > 10 * 1024 * 1024) {
                    alert(`File ${file.name} is too large. Maximum size is 10MB.`);
                    return;
                }
                
                let fileExists = false;
                uploadedFiles.forEach(existingFile => {
                    if (existingFile.name === file.name && existingFile.size === file.size) {
                        fileExists = true;
                    }
                });
                
                if (!fileExists) {
                    uploadedFiles.add(file);
                    fileList.appendChild(createFileItem(file));
                }
            });
            
            updateFilePreviewVisibility();
            
            const dt = new DataTransfer();
            uploadedFiles.forEach(file => dt.items.add(file));
            fileInput.files = dt.files;
        });

        speechButton.addEventListener('click', textToSpeech);
        dictateButton.addEventListener('click', toggleDictation);

        // Form validation
        form.addEventListener('submit', function(event) {
            const fullName = document.querySelector('input[name="fullName"]').value.trim();
            const contactNumber = document.querySelector('input[name="contactNumber"]').value.trim();
            const fraudType = document.querySelector('select[name="fraudType"]').value;
            const incidentDate = document.querySelector('input[name="incidentDate"]').value;
            const description = descriptionTextarea.value.trim();
            const hasAudio = document.getElementById('audioBlobData').value.length > 0;
            const hasFile = uploadedFiles.size > 0;

            // Validate full name
            if (fullName.length < 2) {
                alert('Please enter a valid full name');
                event.preventDefault();
                return false;
            }

            // Validate phone number
            const phoneRegex = /^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4}$/;
            if (!phoneRegex.test(contactNumber)) {
                alert('Please enter a valid contact number');
                event.preventDefault();
                return false;
            }

            // Validate fraud type
            if (!fraudType) {
                alert('Please select a type of fraud');
                event.preventDefault();
                return false;
            }

            // Validate incident date
            const selectedDate = new Date(incidentDate);
            const today = new Date();
            if (selectedDate > today) {
                alert('Incident date cannot be in the future');
                event.preventDefault();
                return false;
            }

            // Validate description
            if (description.length < 10) {
                alert('Please provide a more detailed description (minimum 10 characters)');
                event.preventDefault();
                return false;
            }

            // Validate evidence (either audio or file)
            if (!hasAudio && !hasFile) {
                event.preventDefault();
                evidenceError.classList.add('active');
                return false;
            }

            evidenceError.classList.remove('active');
            return true;
        });
    });
    
    function confirmSubmission() {
        return confirm("You cannot change the details after submitting. Do you want to proceed?");
    }
    </script>
</body>
</html>