#!/bin/bash

# Deployment script for Cloud Run
set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Configuration
PROJECT_ID=${PROJECT_ID:-qwiklabs-gcp-03-07bc42f2b0e6}
SERVICE_NAME="elderly-care-agent"
REGION="europe-west1"
IMAGE_NAME="gcr.io/${PROJECT_ID}/${SERVICE_NAME}"

echo -e "${BLUE}==> Deploying ${SERVICE_NAME} to Cloud Run...${NC}"
echo "   Project: ${PROJECT_ID}"
echo "   Region: ${REGION}"
echo ""

# Step 1: Build and push the container image
echo -e "${BLUE}==> Building container image...${NC}"
gcloud builds submit --tag ${IMAGE_NAME} \
  --project=${PROJECT_ID} \
  --timeout=20m

# Step 2: Deploy to Cloud Run
echo -e "${BLUE}==> Deploying to Cloud Run...${NC}"
gcloud run deploy ${SERVICE_NAME} \
  --image ${IMAGE_NAME} \
  --platform managed \
  --region ${REGION} \
  --allow-unauthenticated \
  --port 8080 \
  --memory 2Gi \
  --cpu 2 \
  --timeout 300 \
  --max-instances 4 \
  --min-instances 0 \
  --concurrency 80 \
  --set-env-vars "GOOGLE_GENAI_USE_VERTEXAI=1,GOOGLE_CLOUD_PROJECT=${PROJECT_ID},GOOGLE_CLOUD_LOCATION=us-central1" \
  --project=${PROJECT_ID}

# Get the service URL
SERVICE_URL=$(gcloud run services describe ${SERVICE_NAME} \
  --region ${REGION} \
  --project ${PROJECT_ID} \
  --format 'value(status.url)')

echo ""
echo -e "${GREEN}==> Deployment complete!${NC}"
echo -e "${GREEN}==>  Service URL: ${SERVICE_URL}${NC}"
echo ""
echo "To test your agent:"
echo "  1. Open: ${SERVICE_URL}"
echo "  2. Click 'Start Audio' and speak"
echo ""
echo "View logs:"
echo "  gcloud run services logs read ${SERVICE_NAME} --region=${REGION} --project=${PROJECT_ID}"

