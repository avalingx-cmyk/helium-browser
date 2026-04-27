// YouTube Ad Blocker Scriptlet
// Blocks YouTube ads by intercepting and removing ad elements

(function() {
    'use strict';
    
    // Remove video ads
    function removeVideoAds() {
        const adSelectors = [
            '.video-ads',
            '.ytp-ad-module',
            '.ytp-ad-overlay-container',
            '.ytp-ad-overlay-slot',
            '#player-ads',
            '.ytd-display-ad-renderer',
            '.ytd-compact-promoted-item-renderer',
            '.ytd-promoted-sparkles-web-renderer',
            '.ytd-video-masthead-ad-v3-renderer',
            '.ytd-banner-promo-renderer',
            '.ytd-brand-video-singleton-renderer'
        ];
        
        adSelectors.forEach(selector => {
            const elements = document.querySelectorAll(selector);
            elements.forEach(el => {
                el.style.display = 'none';
                el.remove();
            });
        });
    }
    
    // Skip ads when possible
    function skipAds() {
        const skipButton = document.querySelector('.ytp-ad-skip-button');
        if (skipButton) {
            skipButton.click();
        }
        
        const skipButtonModern = document.querySelector('.ytp-skip-ad-button');
        if (skipButtonModern) {
            skipButtonModern.click();
        }
    }
    
    // Remove homepage ads
    function removeHomepageAds() {
        const homepageAdSelectors = [
            'ytd-display-ad-renderer',
            'ytd-promoted-sparkles-web-renderer',
            'ytd-promoted-video-renderer',
            '.ytd-carousel-ad-renderer'
        ];
        
        homepageAdSelectors.forEach(selector => {
            const elements = document.querySelectorAll(selector);
            elements.forEach(el => el.remove());
        });
    }
    
    // Main ad blocking loop
    function blockAds() {
        removeVideoAds();
        skipAds();
        removeHomepageAds();
    }
    
    // Run immediately
    blockAds();
    
    // Set up observer for dynamic content
    const observer = new MutationObserver(blockAds);
    observer.observe(document.body, {
        childList: true,
        subtree: true
    });
    
    // Periodic check
    setInterval(blockAds, 1000);
    
    console.log('[Helium Browser] YouTube ad blocker active');
})();
