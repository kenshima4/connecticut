using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;

using connecticut.Classes;

namespace UnitTestConnecticut
{
    [TestClass]
    public class UnitTests
    {
        [TestMethod]
        public void TestSetClientCode()
        {
            // Arrange
            Client c1 = new Client("First National Bank");
            Client c2 = new Client("Protea");
            Client c3 = new Client("IT");
            Client c4 = new Client("AB");
            Client c5 = new Client("Some Client");
            Client c6 = new Client("Far North Bound");



            // Act
            string clientCode1 = c1.getClientCode();
            string clientCode2 = c2.getClientCode();
            string clientCode3 = c3.getClientCode();
            string clientCode4 = c4.getClientCode();
            string clientCode5 = c5.getClientCode();
            string clientCode6 = c6.getClientCode();

            // Assert
            Assert.AreEqual("FNB001", clientCode1);
            Assert.AreEqual("PRO001", clientCode2);
            Assert.AreEqual("ITA001", clientCode3);
            Assert.AreEqual("ABA001", clientCode4);
            Assert.AreEqual("SOC001", clientCode5);
            Assert.AreEqual("FNB002", clientCode6);
        }
    }
}