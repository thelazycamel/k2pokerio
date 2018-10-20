import React from "react"
import ReactDOM from "react-dom"
import { Provider } from 'react-redux'
import { connect } from 'react-redux'

class RulesComponent extends React.Component {

  render() {
    return (
      <Provider store={this.props.store}>
        <div id="rules-root" className={this.props.page.tabs["rules"]}>
          <div id="rules-inner">
            <h2>Rules</h2>
            <div className="collapse navbar-collapse">
              <ul id="rules-navigation" className="navbar-nav">
                <li className="nav-item active">
                  <a href="#" className="nav-link">Tournament Rules</a>
                </li>
                <li className="nav-item">
                  <a href="#" className="nav-link">Card Rankings</a>
                </li>
                <li className="nav-item">
                  <a href="#" className="nav-link">General Rules</a>
                </li>
              </ul>
            </div>
            <div id="rules-tournament" className="rules-section">
            </div>
            <div id="rules-rankings" className="rules-section">
              <ul>
                <li>Royal Flush</li>
                <li>Straight Flush</li>
                <li>Four of a Kind</li>
                <li>Full House</li>
                <li>Flush</li>
                <li>Straight</li>
                <li>Three of a Kind</li>
                <li>Two Pair</li>
                <li>Pair</li>
                <li>High Card</li>
              </ul>
            </div>
            <div id="rules-general" className="rules-section">
              <p>general K2poker rules go here</p>
            </div>
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
