import React, { useState } from "react";
import {
  Input as MTInput,
  Button as MTButton,
  Typography as MTTypography,
  type InputProps,
  type ButtonProps,
  type TypographyProps,
} from "@material-tailwind/react";
import { Link, useNavigate } from "react-router-dom";
import { loginWithEmail, loginWithGoogle } from "../../services/AuthServices";

const GoogleLogo = () => (
  <svg width="24" height="24" viewBox="0 0 48 48">
    <g>
      <path fill="#4285F4" d="M44.5 20H24v8.5h11.7C34.6 33.7 29.7 37 24 37c-7.2 0-13-5.8-13-13s5.8-13 13-13c3.1 0 6 .9 8.3 2.8l6.2-6.2C34.3 4.4 29.4 2.5 24 2.5 12.4 2.5 3 11.9 3 23.5S12.4 44.5 24 44.5c10.7 0 21-8.4 21-21 0-1.4-.1-2.5-.3-3.5z"/>
      <path fill="#34A853" d="M6.3 14.7l7 5.1C14.7 16.8 19 14.5 24 14.5c3.1 0 6 .9 8.3 2.8l6.2-6.2C34.3 4.4 29.4 2.5 24 2.5c-6.9 0-12.8 3.5-16.3 8.6z"/>
      <path fill="#FBBC05" d="M24 44.5c5.7 0 10.6-1.9 14.6-5.1l-7.1-5.8C29.8 35.2 27 36 24 36c-5.6 0-10.4-3.7-12.1-8.8l-7 5.4C7.2 41.1 14.9 44.5 24 44.5z"/>
      <path fill="#EA4335" d="M44.5 20H24v8.5h11.7c-1.1 3.1-3.9 5.5-7.7 6.8l7.1 5.8c4.4-4.1 7-10.1 7-16.8 0-1.4-.1-2.5-.3-3.5z"/>
    </g>
  </svg>
);


// Wrappers for TypeScript
const Input = (props: InputProps) => <MTInput {...(props as any)} />;
const Button = (props: ButtonProps) => <MTButton {...(props as any)} />;
const Typography = (props: TypographyProps) => <MTTypography {...(props as any)} />;

export function SignIn() {
    const [email, setEmail] = useState("");
    const [password, setPassword] = useState("");
    const navigate = useNavigate();
    const [loading, setLoading] = useState(false);

    const handleSignIn = async (e: React.FormEvent) => {
      e.preventDefault();
      setLoading(true);
      try {
        await loginWithEmail(email, password);
        navigate("/dashboard");
      } catch (error) {
        console.error("Login failed", error);
        alert("Login error. Please check your credentials.");
      }finally {
          setLoading(false);
        }
    };

    const handleGoogleSignIn = async () => {
      try {
        await loginWithGoogle();
        navigate("/dashboard");
      } catch (error) {
        console.error("Google login failed", error);
        alert("Google login error.");
      }
    };

  return (
    <section className="flex min-h-screen w-full">
  {/* Left: Sign In Form */}
  <div className="w-1/2 flex flex-col justify-center items-center bg-white">
    <div className="max-w-md w-full">
      <h2 className="text-4xl font-bold mb-4 text-center">Sign In</h2>
      <p className="text-gray-500 mb-8 text-center">
        Enter your email and password to Sign In.
      </p>
      <form className="space-y-6" onSubmit={handleSignIn}>
        <div>
          <label className="block text-gray-700 font-medium mb-1">Your email</label>
          <input
            type="email"
            placeholder="name@mail.com"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            className="w-full rounded-lg border border-gray-300 p-3 focus:border-blue-500 outline-none bg-blue-50"
            required
          />
        </div>
        <div>
          <label className="block text-gray-700 font-medium mb-1">Password</label>
          <input
            type="password"
            placeholder="********"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            className="w-full rounded-lg border border-gray-300 p-3 focus:border-blue-500 outline-none bg-blue-50"
            required
          />
        </div>
        <button
          type="submit"
          disabled={loading}
            className={`w-full bg-black text-white font-semibold py-3 rounded-lg mt-4 transition ${
            loading ? "opacity-50 cursor-not-allowed" : "hover:bg-gray-900"
          }`}
        >
          {loading ? "Please wait..." : "SIGN IN"}
            </button>
            <div className="flex items-center justify-center mt-6">
  <button
    type="button"
    className="flex items-center gap-3 bg-white border border-gray-300 rounded-lg px-5 py-2 shadow hover:bg-gray-50 transition"
    onClick={handleGoogleSignIn}
  >
    <GoogleLogo />
    <span className="font-semibold text-gray-700">Sign in with Google</span>
  </button>
</div>
    
        <div className="flex justify-end mt-2">
          <a href="#" className="text-sm text-gray-500 hover:underline">
            Forgot Password
          </a>
        </div>
      </form>
      <div className="text-center mt-8 font-semibold">
      Not registered?{" "}
      <Link to="/signup" className="text-black underline">
        Create account
      </Link>
    </div>
  </div>

</div>
  {/* Right: Full height & width image */}
  <div className="w-1/2 h-full">
    <img
      src="/img/signin.jpg"   // replace with your image path
      alt="Palm plantation"
      className="w-full h-full object-cover"
      style={{ minHeight: "100vh" }}
    />
  </div>
</section>

  );
}

export default SignIn;
