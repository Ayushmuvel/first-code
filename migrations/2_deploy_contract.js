const todolist = artifacts.require("./todolist");

module.exports = function(deployer) {
  deployer.deploy(todolist);
};
