import $ from 'jquery';
import { HambagerMenu } from './HambagerMenu';

const globalNavControl = new HambagerMenu('globalnav', '#toggle_gnav', 767);
globalNavControl.init();

console.log($.fn.jquery);
