import Translate from "../../js/utils/translate";

const MockApp = {

  settings: {
    page: "gamePlay",
    logged_in: "true",
    tournament_id: 1,
    bots: "true",
    locale: "en"
  },

  t: function(key){
    var translations = new Translate(this.settings.locale);
    this.t = function(key){ return translations.translate(key) }
  }

}

export default MockApp;
