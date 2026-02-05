#!/bin/bash

# Script to create an empty orphan branch
# Usage: ./create-empty-branch.sh <branch-name>

set -e  # Exit on error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if branch name is provided
if [ -z "$1" ]; then
    echo -e "${RED}Error: Branch name is required${NC}"
    echo "Usage: $0 <branch-name>"
    echo "Example: $0 my-empty-branch"
    exit 1
fi

BRANCH_NAME=$1

echo -e "${YELLOW}Creating empty orphan branch: ${BRANCH_NAME}${NC}"
echo ""

# Check if branch already exists
if git show-ref --verify --quiet refs/heads/${BRANCH_NAME}; then
    echo -e "${RED}Error: Branch '${BRANCH_NAME}' already exists locally${NC}"
    echo "Please choose a different name or delete the existing branch first."
    exit 1
fi

# Save current branch
CURRENT_BRANCH=$(git branch --show-current)
echo -e "Current branch: ${CURRENT_BRANCH}"
echo ""

# Create orphan branch
echo -e "${YELLOW}Step 1: Creating orphan branch...${NC}"
git checkout --orphan ${BRANCH_NAME}

# Remove all files from staging
echo -e "${YELLOW}Step 2: Removing all files from staging...${NC}"
git rm -rf . > /dev/null 2>&1 || true

# Verify the branch is empty
echo -e "${YELLOW}Step 3: Verifying branch is empty...${NC}"
STATUS=$(git status --porcelain)

if [ -z "$STATUS" ]; then
    echo -e "${GREEN}✓ Branch is empty and ready!${NC}"
else
    echo -e "${RED}Warning: Branch may not be completely empty${NC}"
fi

echo ""
echo -e "${GREEN}Success! Empty orphan branch '${BRANCH_NAME}' created.${NC}"
echo ""
echo "Next steps:"
echo "  1. Add your files: cp /path/to/files/* ."
echo "  2. Stage files: git add ."
echo "  3. Commit: git commit -m 'Initial commit'"
echo "  4. Push to remote: git push -u origin ${BRANCH_NAME}"
echo ""
echo "To return to your previous branch: git checkout ${CURRENT_BRANCH}"
echo ""
echo "Note: This branch has no commit history and is independent from other branches."
