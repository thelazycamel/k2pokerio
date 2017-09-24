import React from "react"
import ReactDOM from "react-dom"
import { connect } from 'react-redux'
import { Provider } from 'react-redux'

class HeaderNavComponent extends React.Component {

  render() {
    return (
      <Provider store ={this.props.store}>
        <div id="header-nav-component">
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

const ConnectedHeaderNavComponent = connect(mapStateToProps)(HeaderNavComponent)

export default ConnectedHeaderNavComponent;
