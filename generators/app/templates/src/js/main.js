import $ from 'jquery';
import { HambagerMenu } from './modules/HambagerMenu';

const globalNavControl = new HambagerMenu('globalnav', '#toggle_gnav', 767);
globalNavControl.init();

console.log($.fn.jquery);
