import en from "../locales/en"
import es from "../locales/es"

const available_locales = {"en": en, "es": es}

class Translate {

  constructor(locale) {
    if(available_locales[locale] == undefined){
      this.locale = "en";
      this.translations = new available_locales["en"];
    } else {
      this.locale = locale;
      this.translations = new available_locales[locale];
    }
  }

  translate(key) {
    let translation = this.translations.translate()[key];
    if(translation == undefined) {
      translation = key;
    }
    return(translation);
  }

}

export default Translate;
