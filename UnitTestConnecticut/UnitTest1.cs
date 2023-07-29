using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Data.SqlClient;

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

            c1.generateClientCode();
            c2.generateClientCode();
            c3.generateClientCode();
            c4.generateClientCode();
            c5.generateClientCode();
            c6.generateClientCode();


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



[TestClass]
public class IntegrationTests
{
    private string connectionString = "Server=.\\SQLEXPRESS;Database=TestDatabase;Trusted_Connection=True;MultipleActiveResultSets=true";

    [TestInitialize]
    public void TestInitialize()
    {
        // Set up test data in the test database before each test
        using (SqlConnection connection = new SqlConnection(connectionString))
        {
            connection.Open();
            // Insert test data into relevant tables
        }
    }

    [TestCleanup]
    public void TestCleanup()
    {
        // Clean up test data from the test database after each test
        using (SqlConnection connection = new SqlConnection(connectionString))
        {
            connection.Open();
            // Delete test data from relevant tables
        }
    }

    [TestMethod]
    public void TestDatabaseInteraction()
    {
        // Arrange: Set up the test scenario and prepare any input data

        // Act: Perform the database interactions or actions you want to test

        // Assert: Check the results and verify the expected behavior
    }
}