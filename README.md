# Market - Code Snippet

### Introduction/Context

This is a component taken from this [hobby project](https://github.com/arielscherman/grownis2). Feel free to take a look at it if you want to see tests or any other class not included here.

The app is a tool (under development) to manage people investments on different currencies. As a user you can track how much money you win/loose.
For example: You create a Bitcoin wallet and an Ethereum wallet, you can add transaction to keep track of your balances, and the app will calculate your daily winning/looses.
It is mostly useful for countries like Argentina (where I live currently) with weak currencies that are devaluated weekly, so people can know how much money they are loosing by saving money in the local currency.

### Market class

This class is used by a daily job to get the prices of all rates, so then we can calculate how much each wallet is worth (and therefore show users how much they won/lost).
The Market knows how the get the current price of each rate, and some pricing sources provide the price of more than one rate.
Because of that, the Market is smart enough to know whether we need to trigger a new HTTP request or not.

For example: Bitcoin and Ethereum prices are provided by the same endpoint, so if we first fetch the BTC price, there is no need to trigger another HTTP call since we already have the payload we need.

### Glossary

**Rate**: Since there are some currencies that can be measured against different useful values, the Rate defines the association two currencies (ex: 'btc_in_usd'). Each rate has many Values.

### Questions?

Feel free to reach out to me at ariels@hey.com
