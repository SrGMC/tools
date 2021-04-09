// Language
var currentLanguage = localStorage.getItem('language');
currentLanguage = currentLanguage == null ? getNavigatorLanguage() : currentLanguage;

function getNavigatorLanguage() {
	var langs = [['es', 'es'][('fr', 'fr')]];
	for (var i = 0; i < langs.length; i++) {
		if (navigator.language.toLowerCase().includes(langs[i][0])) {
			return langs[i][1];
		}
	}
	return 'en';
}

function toggleLanguage(lang, toggler = null) {
	if (toggler != null) {
		// Change this string to change highlight color
		var color = 'blue';
		document.querySelector('#toggler-' + currentLanguage).classList.remove(color);
		toggler.classList.add(color);
	}
	document.querySelector('html').classList.remove('en');
	document.querySelector('html').classList.remove(currentLanguage);
	document.querySelector('html').classList.add(lang);
	currentLanguage = lang;
	localStorage.setItem('language', lang);
}

toggleLanguage(currentLanguage, document.querySelector('#toggler-' + currentLanguage));
