import $ from 'jquery';

export class HambagerMenu {
    constructor(menuElemId, buttonElemSelector, maxWidth) {
        this.elem = document.getElementById(menuElemId);
        this.$elem = $(this.elem);
        this.menuId = menuElemId;
        this.buttonElem = document.querySelector(buttonElemSelector);
        this.mql = window.matchMedia('(max-width: ' + maxWidth + 'px)');
        this.isMenuOpen = false;
    }

    toggleMenu() {
        if (this.isMenuOpen) {
            // this.elem.style.display = 'none';
            this.$elem.slideUp();
            this.isMenuOpen = false;
            this.elem.setAttribute('aria-hidden', !this.isMenuOpen);
            this.buttonElem.setAttribute('aria-expanded', this.isMenuOpen);
        } else {
            // this.elem.style.display = 'block';
            this.$elem.slideDown();
            this.isMenuOpen = true;
            this.elem.setAttribute('aria-hidden', !this.isMenuOpen);
            this.buttonElem.setAttribute('aria-expanded', this.isMenuOpen);
        }
    }

    enableHambagerMode() {
        this.elem.style.display = 'none';
        this.buttonElem.style.display = 'inline-block';
        this.buttonElem.setAttribute('aria-expanded', this.isMenuOpen);
        this.buttonElem.setAttribute('aria-controls', this.menuId);
    }

    disablehambagerMode() {
        this.elem.style.display = 'flex';
        this.buttonElem.style.display = 'none';
    }

    init() {
        this.mql.addListener((e) => {
            if (e.matches) {
                this.enableHambagerMode();
            } else {
                this.disablehambagerMode();
            }
        });
        if (this.mql.matches) {
            this.enableHambagerMode();
        } else {
            this.disablehambagerMode();
        }
        this.buttonElem.addEventListener('click', () => {
            this.toggleMenu();
        });
    }
};
