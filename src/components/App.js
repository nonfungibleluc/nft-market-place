import React, { Component } from "react";
import Web3 from "web3";
import detectEthereumProvider from "@metamask/detect-provider";
import KryptoBird from "../abis/Kryptobird.json";

class App extends Component {

    async componentDidMount() {
        await this.loadWeb3();
        await this.loadBlockchainData()
    }

    // first up is to detect an ethereum
    async loadWeb3() {
        const provider = await detectEthereumProvider();
        // modern browsers
        // if there is a provider then let's log that it's working and access the window from the doc to set Web3 to the provider
        if (provider) {
            console.log('ethereum wallet is connected');
            window.web3 = new Web3(provider);
        } else {
            console.log('No ethereum wallet available');
        }
    };

    async loadBlockchainData() {
        const web3 = window.web3;
        const accounts = await web3.eth.getAccounts();
        this.setState({
            account: accounts
        })

        // create a constant js variable networkID which is set to blobkchain network id
        const networkId = await web3.eth.net.getId();
        const networkData = KryptoBird.networks[networkId];

        if(networkData){
            const abi = KryptoBird.abi;
            const address = networkData.address;
            const contract = new web3.eth.Contract(abi, address);
            console.log(contract);
        }

    }

    constructor(props) {
        super(props);
        this.state = {
            account: ''
        }
    }

    render() {
        return (
            <div>
                <nav className='navbar navbar-dark fixed-top bg-dark flex-md-nowrap p-0 shaddow'>
                    <div className="navbar-brand col-sm-3 col-md-3 mr-0" style={{color: 'white'}}>
                        Krypto Birdz NFT (Non Fungible Tokens)
                    </div>
                    <ul className='navbar-nav px-3'>
                        <li className='nav-item text-nowrap d-sm-block'>
                            <small className='text-white'>{this.state.account}</small>
                        </li>
                    </ul>
                </nav>
            </div>
        )
    }
}

export default App;