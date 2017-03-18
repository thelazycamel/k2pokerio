import React from "react"
import ReactDOM from "react-dom"
import { Provider } from 'react-redux'
import { connect } from 'react-redux'

class RulesComponent extends React.Component {

  render() {
    return (<Provider store={this.props.store}>
        <div id="rules-root">
          <h2>Rules</h2>
          <p>Current Tournament Rules</p>
          <p>Card Rankings</p>
          <p>General K2 Poker Rules</p>
        </div>
      </Provider>)
  }
}

const mapStateToProps = (state) => {
  return {
    page: state.page
  }
}

const ConnectedRulesComponent = connect(mapStateToProps)(RulesComponent)


export default ConnectedRulesComponent;
