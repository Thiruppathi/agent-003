# Good Agent.AI

AI-powered elderly care agent with voice support built with Google Agent Development Kit (ADK) and Vertex AI.

**AI Agents Live + Labs - Benelux Hackathon**

**Live Demo:** [https://elderly-care-agent-cwgynx23zq-ew.a.run.app/](https://elderly-care-agent-cwgynx23zq-ew.a.run.app/)

## Overview

Millions of elderly people live alone, and caregivers are overwhelmed. "Good Agent.AI" is a proactive, voice-first AI caretaker, "Brian," who provides daily companionship and intelligent safety monitoring, only alerting caregivers when help is actually needed.

The Problem:

* For Seniors: High risk of falls, missed medication, and profound loneliness.
* For Caregivers: Constant stress, "alert fatigue," and the burden of repetitive check-ins.

## Core Features (Powered by Gemini & Genkit):

* Proactive Voice Check-ins: Brian initiates natural, human-like conversations.
* Intelligent Risk Assessment: Gemini's logic understands the *intent and urgency* behind a user's words (e.g., "I've fallen!" vs. "I fell asleep").
* Autonomous Escalation: The agent *acts* on high-risk events, autonomously sending real-time SMS alerts to caregivers.
* Personal Memory & Companionship: The agent remembers key details (names, past events) to build genuine rapport and combat loneliness.
- **Voice Support**: Real-time audio streaming with Gemini Live
- **Text Chat**: Traditional text-based interactions
- **Health Monitoring**: Tracks beneficiary state and provides assistance
- **Calendar Integration**: Reminds users of their daily plans
- **Emergency Support**: Can contact emergency services or emergency contacts
- **Web Interface**: Modern, accessible UI for easy interaction


## Prerequisites

1. **Python 3.12+**
2. **Google Cloud SDK installed and authenticated:**
```bash
gcloud auth login
gcloud config set project qwiklabs-gcp-03-07bc42f2b0e6
```

3. **Enable required APIs:**
```bash
gcloud services enable run.googleapis.com
gcloud services enable cloudbuild.googleapis.com
gcloud services enable artifactregistry.googleapis.com
gcloud services enable aiplatform.googleapis.com
```

## Local Development

### Setup

1. **Clone the repository**
```bash
cd agent-003
```

2. **Install dependencies**
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
uv venv && source .venv/bin/activate && uv sync
```

3. **Create `.env` file** (for local development):
```bash
cat > .env << EOF
GOOGLE_GENAI_USE_VERTEXAI=1
GOOGLE_CLOUD_PROJECT=qwiklabs-gcp-03-07bc42f2b0e6
GOOGLE_CLOUD_LOCATION=us-central1
EOF
```

### Run Locally

```bash
export SSL_CERT_FILE=$(python -m certifi)
uvicorn main:app --reload --port 8080
```

Then open http://localhost:8080 in your browser.

## Deployment to Cloud Run

### Option 1: Using the deploy script (Recommended)

Simply run:
```bash
bash deploy.sh
```

The script will:
- Build the container image
- Push it to Google Container Registry
- Deploy to Cloud Run with proper configuration
- Output the service URL

### Option 2: Manual deployment

**Build and push the image:**
```bash
gcloud builds submit --tag gcr.io/qwiklabs-gcp-03-07bc42f2b0e6/elderly-care-agent \
  --project=qwiklabs-gcp-03-07bc42f2b0e6 \
  --timeout=20m
```

**Deploy to Cloud Run:**
```bash
gcloud run deploy elderly-care-agent \
  --image gcr.io/qwiklabs-gcp-03-07bc42f2b0e6/elderly-care-agent \
  --platform managed \
  --region europe-west1 \
  --allow-unauthenticated \
  --port 8080 \
  --memory 2Gi \
  --cpu 2 \
  --timeout 300 \
  --max-instances 4 \
  --min-instances 0 \
  --concurrency 80 \
  --set-env-vars "GOOGLE_GENAI_USE_VERTEXAI=1,GOOGLE_CLOUD_PROJECT=qwiklabs-gcp-03-07bc42f2b0e6,GOOGLE_CLOUD_LOCATION=us-central1" \
  --project=qwiklabs-gcp-03-07bc42f2b0e6
```

## Using the Deployed Agent

The agent is currently deployed at: **[https://elderly-care-agent-cwgynx23zq-ew.a.run.app/](https://elderly-care-agent-cwgynx23zq-ew.a.run.app/)**

After deploying your own instance, you'll receive a service URL like:
```
https://elderly-care-agent-XXXXXXXXXX.europe-west1.run.app
```

### Audio Mode
1. Open the URL in your browser
2. Click "Start Audio" button
3. Allow microphone access when prompted
4. Speak naturally - Brian will respond with voice


## Monitoring and Logs

**View logs:**
```bash
gcloud run services logs read elderly-care-agent \
  --region=europe-west1 \
  --project=qwiklabs-gcp-03-07bc42f2b0e6
```

## Technologies Used

- **Google Agent Development Kit (ADK)**: Agent framework
- **Vertex AI**: Gemini Live model for audio/text generation
- **FastAPI**: Web server with Server-Sent Events (SSE)
- **Cloud Run**: Serverless deployment platform
- **Web Audio API**: Real-time audio processing

