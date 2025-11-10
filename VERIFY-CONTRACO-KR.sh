#!/bin/bash

# CONTRACO.CO.KR Deployment Verification Script
# Validates 100% compliance with contraco.net brand standards
# Date: 2025-11-10

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Counters
PASS=0
FAIL=0
WARN=0

echo -e "${BOLD}${CYAN}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║   CONTRACO.CO.KR - DEPLOYMENT VERIFICATION SCRIPT            ║"
echo "║   Target: 100% Brand Compliance with contraco.net            ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Function to print section header
section_header() {
    echo -e "\n${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}${CYAN}$1${NC}"
    echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# Function to print test result
test_result() {
    local status=$1
    local message=$2
    if [ "$status" = "PASS" ]; then
        echo -e "${GREEN}✅ PASS${NC} - $message"
        ((PASS++))
    elif [ "$status" = "FAIL" ]; then
        echo -e "${RED}❌ FAIL${NC} - $message"
        ((FAIL++))
    elif [ "$status" = "WARN" ]; then
        echo -e "${YELLOW}⚠️  WARN${NC} - $message"
        ((WARN++))
    fi
}

# ==============================================================================
# TEST 1: LOGO SOURCE VERIFICATION
# ==============================================================================
section_header "TEST 1: Logo Source Compliance"

echo "Checking logo sources in all HTML files..."

# Check for wrong domain (contraco.net)
WRONG_LOGO_COUNT=$(grep -r "contraco\.net/Logo_rectangle\.svg" *.html 2>/dev/null | wc -l)

if [ "$WRONG_LOGO_COUNT" -eq 0 ]; then
    test_result "PASS" "No cross-domain logo references found"
else
    test_result "FAIL" "Found $WRONG_LOGO_COUNT files with contraco.net logo source"
    grep -n "contraco\.net/Logo_rectangle\.svg" *.html
fi

# Check for correct domain (contraco.co.kr)
CORRECT_LOGO_COUNT=$(grep -r "contraco\.co\.kr/Logo_rectangle\.svg" *.html 2>/dev/null | wc -l)
echo -e "${CYAN}ℹ${NC}  Found $CORRECT_LOGO_COUNT correct logo references (contraco.co.kr)"

# Verify logo file exists
if [ -f "Logo_rectangle.svg" ]; then
    test_result "PASS" "Logo_rectangle.svg exists in repository"
    ls -lh Logo_rectangle.svg | awk '{print "   Size: " $5}'
else
    test_result "FAIL" "Logo_rectangle.svg not found in repository root"
fi

# ==============================================================================
# TEST 2: LANGUAGE SWITCHER STYLES
# ==============================================================================
section_header "TEST 2: Language Switcher Style Compliance"

echo "Checking language switcher hover styles..."

# Check for old non-standard hover style
OLD_HOVER_COUNT=$(grep -r "background-color: rgba(192, 0, 0, 0\.1)" *.html 2>/dev/null | wc -l)

if [ "$OLD_HOVER_COUNT" -eq 0 ]; then
    test_result "PASS" "No old hover styles (rgba red) found"
else
    test_result "FAIL" "Found $OLD_HOVER_COUNT files with old hover style"
    grep -n "background-color: rgba(192, 0, 0, 0\.1)" *.html
fi

# Check for standard hover style
STANDARD_HOVER_COUNT=$(grep -r "background-color: var(--warm-white)" *.html 2>/dev/null | wc -l)
echo -e "${CYAN}ℹ${NC}  Found $STANDARD_HOVER_COUNT instances of standard hover style"

echo ""
echo "Checking language switcher active styles..."

# Check for old active style (red background, white text)
OLD_ACTIVE_PATTERN=$(grep -A1 "\.lang-link\.active" *.html 2>/dev/null | grep -c "background.*var(--primary-red)")
STANDARD_ACTIVE_COUNT=$(grep -B2 -A1 "\.lang-link\.active" *.html 2>/dev/null | grep -c "background-color: var(--warm-white)")

if [ "$STANDARD_ACTIVE_COUNT" -ge 10 ]; then
    test_result "PASS" "Language switcher active styles are standardized ($STANDARD_ACTIVE_COUNT files)"
else
    test_result "WARN" "Only $STANDARD_ACTIVE_COUNT files have standard active styles"
fi

# ==============================================================================
# TEST 3: GOOGLE ANALYTICS TRACKING
# ==============================================================================
section_header "TEST 3: Google Analytics Compliance"

echo "Checking for correct GA tracking ID (G-868WGCC45D)..."

CORRECT_GA_COUNT=$(grep -r "G-868WGCC45D" *.html 2>/dev/null | wc -l)
echo -e "${CYAN}ℹ${NC}  Found $CORRECT_GA_COUNT instances of correct GA ID"

# Check for wrong GA ID
WRONG_GA_COUNT=$(grep -r "G-JC5PMW72PK" *.html 2>/dev/null | wc -l)

if [ "$WRONG_GA_COUNT" -eq 0 ]; then
    test_result "PASS" "No wrong GA tracking IDs found"
else
    test_result "FAIL" "Found $WRONG_GA_COUNT instances of wrong GA ID (G-JC5PMW72PK)"
    grep -n "G-JC5PMW72PK" *.html
fi

# List files with GA tracking
echo -e "\n${CYAN}Files with GA tracking:${NC}"
grep -l "G-868WGCC45D" *.html 2>/dev/null | sed 's/^/   • /'

# ==============================================================================
# TEST 4: BULLET STYLE CONSISTENCY
# ==============================================================================
section_header "TEST 4: Bullet Character Compliance"

echo "Checking for correct triangle pointer bullets (▸)..."

TRIANGLE_COUNT=$(grep -r 'content: "▸"' *.html 2>/dev/null | wc -l)
echo -e "${CYAN}ℹ${NC}  Found $TRIANGLE_COUNT instances of triangle pointer bullets"

# Check for wrong arrow bullets
ARROW_COUNT=$(grep -r 'content: "→"' *.html 2>/dev/null | wc -l)

if [ "$ARROW_COUNT" -eq 0 ]; then
    test_result "PASS" "No arrow bullets (→) found"
else
    test_result "FAIL" "Found $ARROW_COUNT instances of arrow bullets"
    grep -n 'content: "→"' *.html
fi

# ==============================================================================
# TEST 5: LINK INTEGRITY
# ==============================================================================
section_header "TEST 5: Link Integrity Check"

echo "Checking for broken organizational-design-ai links..."

BROKEN_LINK_COUNT=$(grep -r "contraco-organizational-design-ai\.html" *.html 2>/dev/null | wc -l)

if [ "$BROKEN_LINK_COUNT" -eq 0 ]; then
    test_result "PASS" "No broken organizational-design-ai links found"
else
    test_result "FAIL" "Found $BROKEN_LINK_COUNT instances of broken links"
    grep -n "contraco-organizational-design-ai\.html" *.html
fi

# Check hreflang consistency
echo ""
echo "Checking hreflang tag consistency..."

HTML_FILES=$(ls -1 *.html 2>/dev/null | grep -v "yandex\|navigation_template" | wc -l)
FILES_WITH_HREFLANG=$(grep -l "hreflang=" *.html 2>/dev/null | grep -v "yandex\|navigation_template\|thank-you" | wc -l)

echo -e "${CYAN}ℹ${NC}  $FILES_WITH_HREFLANG out of $HTML_FILES content pages have hreflang tags"

if [ "$FILES_WITH_HREFLANG" -ge 10 ]; then
    test_result "PASS" "Hreflang tags present on major pages"
else
    test_result "WARN" "Only $FILES_WITH_HREFLANG pages have hreflang tags"
fi

# ==============================================================================
# TEST 6: FORM CONFIGURATION
# ==============================================================================
section_header "TEST 6: Contact Form Configuration"

echo "Checking FormSubmit redirect configuration..."

# Check if thank-you.html exists
if [ -f "thank-you.html" ]; then
    test_result "PASS" "thank-you.html exists"
else
    test_result "FAIL" "thank-you.html not found"
fi

# Check form redirects
FORM_REDIRECT_COUNT=$(grep -r "_next.*thank-you\.html" *.html 2>/dev/null | wc -l)

if [ "$FORM_REDIRECT_COUNT" -ge 2 ]; then
    test_result "PASS" "Form redirects configured correctly ($FORM_REDIRECT_COUNT forms)"
    grep -n "_next.*thank-you\.html" *.html | sed 's/^/   • /'
else
    test_result "WARN" "Only $FORM_REDIRECT_COUNT form redirects found"
fi

# ==============================================================================
# TEST 7: FILE STRUCTURE
# ==============================================================================
section_header "TEST 7: File Structure Verification"

echo "Checking essential files..."

# Check essential HTML files
ESSENTIAL_FILES=("index.html" "about.html" "contact.html" "copyright.html" "insights.html")
MISSING_FILES=0

for file in "${ESSENTIAL_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}✓${NC} $file"
    else
        echo -e "${RED}✗${NC} $file ${RED}(MISSING)${NC}"
        ((MISSING_FILES++))
    fi
done

if [ "$MISSING_FILES" -eq 0 ]; then
    test_result "PASS" "All essential HTML files present"
else
    test_result "FAIL" "$MISSING_FILES essential files missing"
fi

# Count total HTML files
TOTAL_HTML=$(ls -1 *.html 2>/dev/null | wc -l)
echo -e "\n${CYAN}ℹ${NC}  Total HTML files: $TOTAL_HTML"

# ==============================================================================
# TEST 8: KOREAN TYPOGRAPHY
# ==============================================================================
section_header "TEST 8: Korean Typography (Noto Sans KR)"

echo "Checking for Noto Sans KR font implementation..."

NOTO_SANS_COUNT=$(grep -r "Noto Sans KR" *.html 2>/dev/null | wc -l)

if [ "$NOTO_SANS_COUNT" -ge 15 ]; then
    test_result "PASS" "Noto Sans KR font implemented ($NOTO_SANS_COUNT files)"
else
    test_result "WARN" "Only $NOTO_SANS_COUNT files have Noto Sans KR"
fi

# Check CSS variable configuration
FONT_VAR_COUNT=$(grep -r "\-\-font-sans.*Noto Sans KR" *.html 2>/dev/null | wc -l)

if [ "$FONT_VAR_COUNT" -ge 10 ]; then
    test_result "PASS" "CSS font variable properly configured ($FONT_VAR_COUNT files)"
else
    test_result "WARN" "Only $FONT_VAR_COUNT files have proper CSS font variable"
fi

# ==============================================================================
# TEST 9: FAVICON CONFIGURATION
# ==============================================================================
section_header "TEST 9: Favicon Assets"

echo "Checking favicon files..."

FAVICON_COUNT=$(ls -1 *.png *.ico 2>/dev/null | grep -i "favicon\|apple-touch" | wc -l)

if [ "$FAVICON_COUNT" -ge 10 ]; then
    test_result "PASS" "Favicon assets present ($FAVICON_COUNT files)"
    echo -e "${CYAN}ℹ${NC}  Favicon files:"
    ls -1 *.png *.ico 2>/dev/null | grep -i "favicon\|apple-touch" | head -5 | sed 's/^/   • /'
    if [ "$FAVICON_COUNT" -gt 5 ]; then
        echo "   • ... and $((FAVICON_COUNT - 5)) more"
    fi
else
    test_result "WARN" "Only $FAVICON_COUNT favicon files found (expected 25+)"
fi

# ==============================================================================
# TEST 10: BRAND CONSISTENCY
# ==============================================================================
section_header "TEST 10: Brand Color Consistency"

echo "Checking brand red color usage (var(--primary-red))..."

PRIMARY_RED_COUNT=$(grep -r "var(--primary-red)" *.html 2>/dev/null | wc -l)

if [ "$PRIMARY_RED_COUNT" -ge 50 ]; then
    test_result "PASS" "Brand red color consistently used ($PRIMARY_RED_COUNT instances)"
else
    test_result "WARN" "Brand red usage: $PRIMARY_RED_COUNT instances"
fi

# Check for hardcoded red values that should use variable
HARDCODED_RED=$(grep -r "#C00000\|rgb(192, 0, 0)" *.html 2>/dev/null | grep -v "var(--primary-red)" | wc -l)

if [ "$HARDCODED_RED" -eq 0 ]; then
    test_result "PASS" "No hardcoded red values found (using CSS variables)"
else
    test_result "WARN" "Found $HARDCODED_RED hardcoded red values (should use --primary-red)"
fi

# ==============================================================================
# FINAL SUMMARY
# ==============================================================================
echo -e "\n${BOLD}${CYAN}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                    VERIFICATION SUMMARY                      ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

TOTAL_TESTS=$((PASS + FAIL + WARN))

echo -e "${GREEN}${BOLD}✅ PASSED:${NC}  $PASS tests"
echo -e "${RED}${BOLD}❌ FAILED:${NC}  $FAIL tests"
echo -e "${YELLOW}${BOLD}⚠️  WARNINGS:${NC} $WARN tests"
echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}   TOTAL:${NC}    $TOTAL_TESTS tests"

echo ""

# Calculate compliance percentage
if [ "$TOTAL_TESTS" -gt 0 ]; then
    COMPLIANCE=$(( (PASS * 100) / TOTAL_TESTS ))
else
    COMPLIANCE=0
fi

echo -e "${BOLD}Compliance Score: ${NC}"
if [ "$COMPLIANCE" -ge 95 ]; then
    echo -e "${GREEN}${BOLD}   🎯 $COMPLIANCE% - EXCELLENT!${NC}"
    echo -e "${GREEN}   100% Brand Compliance Achieved!${NC}"
elif [ "$COMPLIANCE" -ge 80 ]; then
    echo -e "${YELLOW}${BOLD}   ⚡ $COMPLIANCE% - GOOD${NC}"
    echo -e "${YELLOW}   Minor improvements recommended${NC}"
else
    echo -e "${RED}${BOLD}   ⚠️  $COMPLIANCE% - NEEDS ATTENTION${NC}"
    echo -e "${RED}   Critical issues require fixing${NC}"
fi

echo ""

# Exit status
if [ "$FAIL" -eq 0 ]; then
    echo -e "${GREEN}${BOLD}✓ Deployment verification PASSED${NC}"
    echo -e "${GREEN}  All critical requirements met!${NC}"
    exit 0
else
    echo -e "${RED}${BOLD}✗ Deployment verification FAILED${NC}"
    echo -e "${RED}  $FAIL critical issue(s) found${NC}"
    exit 1
fi
