'use client';

import { useState } from "react";
import { useRouter } from "next/navigation";

export default function LoginPage() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [message, setMessage] = useState("");
  const router = useRouter(); // To handle redirection after login

  const handleLogin = async (e) => {
    e.preventDefault();
    setMessage("");

    if (!email || !password) {
      setMessage("Please fill in all fields.");
      return;
    }

    try {
      // Simulating API call
      console.log("User login data:", { email, password });
      
      // Simulate a successful login
      setMessage("Login successful! Welcome back.");
      
      // Redirect to the upload page after successful login
      router.push("/upload");  // Change this to the path where you want to go after login
    } catch (error) {
      setMessage("Invalid credentials. Please try again.");
    }
  };

  return (
    <div className="relative flex items-center justify-center h-screen bg-gray-100">
      <div className="absolute top-4 left-4 text-xl font-bold text-blue-600">
        MyAppLogo
      </div>
      <div className="w-full max-w-sm p-6 bg-white rounded-lg shadow-md">
        <h2 className="mb-6 text-2xl font-bold text-center">Log In</h2>
        <form onSubmit={handleLogin}>
          <div className="mb-4">
            <label htmlFor="email" className="block mb-2 text-sm font-medium">
              Email Address
            </label>
            <input
              type="email"
              id="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              className="w-full p-2 border border-gray-300 rounded-lg focus:ring focus:ring-blue-300"
              placeholder="Enter your email"
              required
            />
          </div>
          <div className="mb-4">
            <label htmlFor="password" className="block mb-2 text-sm font-medium">
              Password
            </label>
            <input
              type="password"
              id="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              className="w-full p-2 border border-gray-300 rounded-lg focus:ring focus:ring-blue-300"
              placeholder="Enter your password"
              required
            />
          </div>
          {message && (
            <p className="mb-4 text-sm text-center text-red-500">{message}</p>
          )}
          <button
            type="submit"
            className="w-full py-2 text-white bg-blue-500 rounded-lg hover:bg-blue-600 focus:outline-none focus:ring focus:ring-blue-300"
          >
            Log In
          </button>
        </form>
      </div>
    </div>
  );
}