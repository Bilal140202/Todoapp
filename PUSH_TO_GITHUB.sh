#!/bin/bash
# Script to push Premium Notes App to GitHub

echo "🚀 Pushing Premium Notes App to GitHub..."
echo ""
echo "Repository: https://github.com/Bilal140202/Todoapp.git"
echo ""

cd /data/data/com.termux/files/home/premium_notes_app

echo "📊 Current Status:"
git status

echo ""
echo "📤 Pushing to GitHub..."
git push -u origin main

echo ""
echo "✅ Done! Check your repository at:"
echo "https://github.com/Bilal140202/Todoapp"
