import React from "react";

export default function ContactSection() {
  return (
    <section id="contact" className="py-20 px-6 max-w-6xl mx-auto">
      <h2 className="text-4xl font-bold text-center mb-10">
        Get in <span className="text-green-600">Touch</span>
      </h2>
      <div className="flex flex-col md:flex-row gap-10">
        {/* Left: Demo Form */}
        <form className="flex-1 bg-green-50 p-8 rounded-xl shadow space-y-5">
          <div className="font-bold text-lg mb-4">Request a Demo</div>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <input className="p-3 rounded border" placeholder="First Name" />
            <input className="p-3 rounded border" placeholder="Last Name" />
          </div>
          <input className="p-3 rounded border w-full" placeholder="Email Address" />
          <input className="p-3 rounded border w-full" placeholder="Farm Size (acres)" />
          <textarea className="p-3 rounded border w-full" placeholder="Tell us about your farming operation and how we can help..." rows={3} />
          <button className="bg-green-600 text-white px-6 py-3 rounded hover:bg-green-700 w-full mt-3">Request Demo</button>
        </form>
        {/* Right: Contact Info */}
        <div className="flex-1 flex flex-col gap-5">
          <div className="bg-white p-8 rounded-xl shadow">
            <div className="font-bold mb-3">Contact Information</div>
            <div className="flex items-center gap-3 mb-2">
              <span className="bg-green-100 text-green-600 rounded-full w-8 h-8 flex items-center justify-center text-lg">✉️</span>
              <div>
                <div className="font-semibold">Email</div>
                <div className="text-sm text-gray-600">contact@sams-agri.com</div>
              </div>
            </div>
            <div className="flex items-center gap-3 mb-2">
              <span className="bg-blue-100 text-blue-600 rounded-full w-8 h-8 flex items-center justify-center text-lg">📞</span>
              <div>
                <div className="font-semibold">Phone</div>
                <div className="text-sm text-gray-600">+1 (555) 123-4567</div>
              </div>
            </div>
            <div className="flex items-center gap-3 mb-2">
              <span className="bg-green-100 text-green-600 rounded-full w-8 h-8 flex items-center justify-center text-lg">📍</span>
              <div>
                <div className="font-semibold">Address</div>
                <div className="text-sm text-gray-600">123 AgriTech Plaza, Innovation City, CA 94158</div>
              </div>
            </div>
          </div>
          <div className="bg-gray-900 text-white rounded-xl shadow p-6 mt-4">
            <div className="font-bold mb-2">Why Choose SAMS?</div>
            <ul className="space-y-1 text-sm">
              <li>• Industry-leading accuracy and reliability</li>
              <li>• 24/7 customer support and training</li>
              <li>• Secure, scalable, and user-friendly platform</li>
            </ul>
          </div>
        </div>
      </div>
    </section>
  );
}
