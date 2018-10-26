import React from "react"
import ReactDOM from "react-dom"
import { Provider } from 'react-redux'
import { connect } from 'react-redux'

class RulesComponent extends React.Component {

  constructor(props) {
    super(props);
    this.state = {
      tab: "rankings",
      tournament_type: App.settings.tournament_type
    }
  }

  changeTab(tab) {
    this.setState({tab: tab});
  }

  renderBody() {
    switch(this.state.tab) {
      case "tournament":
        if(this.state.tournament_type == "tournament") {
          return this.renderTournamentRules();
        } else {
          return this.renderDuelRules();
        }
        break;
      case "rankings":
        return this.renderCardRankings();
        break;
    }
  }

  renderTournamentRules() {
    return(
      <div className="rules-section tournament-rules">
        <ol>
          <li>{ App.t("tournament_rules_1") }</li>
          <li>{ App.t("tournament_rules_2") }</li>
          <li>{ App.t("tournament_rules_3") }</li>
          <li>{ App.t("tournament_rules_4") }</li>
          <li>{ App.t("tournament_rules_5") }</li>
          <li>{ App.t("tournament_rules_6") }</li>
        </ol>

      </div>
    )
  }

  renderDuelRules() {
    return(
      <div className="rules-section tournament-rules">
        <ol>
          <li>{ App.t("duel_rules_1") }</li>
          <li>{ App.t("tournament_rules_2") }</li>
          <li>{ App.t("duel_rules_3") }</li>
          <li>{ App.t("duel_rules_4") }</li>
          <li>{ App.t("duel_rules_5") }</li>
        </ol>
      </div>
    )
  }

  renderCardRankings() {
    return(
      <div className="rules-section card-rankings">
      <p>1. { App.t("royal_flush") }</p>
      <img src="/images/hand-rankings/royal-flush.svg" alt="Royal Flush" className="hand-ranking" title="Royal Flush"/>
      <p>2. { App.t("straight_flush") }</p>
      <img src="/images/hand-rankings/straight-flush.svg" alt="Straight Flush" className="hand-ranking" title="Straight Flush"/>
      <p>3. { App.t("four_of_a_kind") }</p>
      <img src="/images/hand-rankings/four-of-a-kind.svg" alt="Four of a Kind" className="hand-ranking" title="Four of a Kind"/>
      <p>4. { App.t("full_house") }</p>
      <img src="/images/hand-rankings/full-house.svg" alt="Full House" className="hand-ranking" title="Full House"/>
      <p>5. { App.t("flush") }</p>
      <img src="/images/hand-rankings/flush.svg" alt="Flush" className="hand-ranking" title="Flush"/>
      <p>6. { App.t("straight") }</p>
      <img src="/images/hand-rankings/straight.svg" alt="Straight" className="hand-ranking" title="Straight"/>
      <p>7. { App.t("three_of_a_kind") }</p>
      <img src="/images/hand-rankings/three-of-a-kind.svg" alt="Three of a Kind" className="hand-ranking" title="Three of a Kind"/>
      <p>8. { App.t("two_pair") }</p>
      <img src="/images/hand-rankings/two-pair.svg" alt="Two Pair" className="hand-ranking" title="Two Pair"/>
      <p>9. { App.t("pair") }</p>
      <img src="/images/hand-rankings/pair.svg" alt="Pair" className="hand-ranking" title="Pair" />
      <p>10. { App.t("high_card") }</p>
      <img src="/images/hand-rankings/high-card.svg" alt="High Card" className="hand-ranking" title="High Card" />
      </div>
    )
  }

  tabLinkClass(tab) {
   let classes = ["tab-link"];
   if(tab == this.state.tab) {
     classes.push("active");
   }
   return classes.join(" ");
  }

  render() {
    return (
      <Provider store={this.props.store}>
        <div id="rules-root" className={this.props.page.tabs["rules"]}>
          <div id="rules-inner">
            <div id="rules-navigation">
              <div className={ this.tabLinkClass("rankings") } onClick={ this.changeTab.bind(this, "rankings") }>
                { App.t("card_rankings_tab") }
              </div>
              <div className={ this.tabLinkClass("tournament")} onClick={ this.changeTab.bind(this, "tournament") }>
                { App.t(this.state.tournament_type + "_rules_tab") }
              </div>
            </div>
            { this.renderBody() }
          </div>
        </div>
      </Provider>
    )
  }
}

const mapStateToProps = (state) => {
  return {
    page: state.page
  }
}

const ConnectedRulesComponent = connect(mapStateToProps)(RulesComponent)


export default ConnectedRulesComponent;
