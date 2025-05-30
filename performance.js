// Performance monitoring
const performanceMetrics = {
    init() {
        this.observeImages();
        this.trackPageLoad();
    },

    observeImages() {
        const images = document.querySelectorAll('img');
        const imageObserver = new PerformanceObserver((list) => {
            for (const entry of list.getEntries()) {
                if (entry.initiatorType === 'img') {
                    console.log(`Image loaded: ${entry.name} in ${entry.duration.toFixed(2)}ms`);
                }
            }
        });

        imageObserver.observe({ entryTypes: ['resource'] });
    },

    trackPageLoad() {
        window.addEventListener('load', () => {
            const timing = performance.timing;
            const pageLoadTime = timing.loadEventEnd - timing.navigationStart;
            console.log(`Page load time: ${pageLoadTime}ms`);
        });
    }
};

// Image loading optimization
const imageLoader = {
    init() {
        this.setupIntersectionObserver();
        this.setupErrorHandling();
    },

    setupIntersectionObserver() {
        const options = {
            root: null,
            rootMargin: '50px',
            threshold: 0.1
        };

        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    const img = entry.target;
                    if (img.dataset.src) {
                        img.src = img.dataset.src;
                        observer.unobserve(img);
                    }
                }
            });
        }, options);

        document.querySelectorAll('img[data-src]').forEach(img => {
            observer.observe(img);
        });
    },

    setupErrorHandling() {
        document.querySelectorAll('img').forEach(img => {
            img.addEventListener('error', () => {
                img.src = 'assets/placeholder.png';
                img.alt = 'Image not available';
            });
        });
    }
};

// Initialize when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
    performanceMetrics.init();
    imageLoader.init();
}); 