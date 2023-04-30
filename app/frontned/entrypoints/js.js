import $ from 'jquery';
window.$ = $;
import '../semantic/dist/semantic.min';
import 'jquery-address';

// Hotwired
import * as Turbo from '@hotwired/turbo'
Turbo.start()

import '../controllers/index';