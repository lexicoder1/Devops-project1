'use client';

import { useState } from "react";
import { useRouter } from "next/navigation";

export default function UploadPage() {
  const [selectedImage, setSelectedImage] = useState(null);
  const [uploadedImage, setUploadedImage] = useState(null);
  const router = useRouter(); // Initialize the router

  const handleImageChange = (e) => {
    const file = e.target.files[0];
    if (file) {
      setSelectedImage(URL.createObjectURL(file));
    }
  };

  const handleImageUpload = async () => {
    if (!selectedImage) {
      alert("Please select an image.");
      return;
    }

    // Simulating an image upload
    console.log("Uploading image:", selectedImage);

    // Assuming upload is successful
    setUploadedImage(selectedImage);
    alert("Image uploaded successfully!");
  };

  const handleNavigate = () => {
    router.push("/contents"); // Navigate to /contents
  };

  return (
    <div className="relative flex items-center justify-center h-screen bg-gray-100">
      <div className="absolute top-4 left-4 text-xl font-bold text-blue-600">
        MyAppLogo
      </div>
      <div className="w-full max-w-md p-6 bg-white rounded-lg shadow-md">
        <h2 className="mb-6 text-2xl font-bold text-center">Upload Image</h2>
        <div className="mb-4">
          <input
            type="file"
            accept="image/*"
            onChange={handleImageChange}
            className="w-full p-2 border border-gray-300 rounded-lg"
          />
        </div>
        {selectedImage && (
          <div className="mb-4 text-center">
            <img src={selectedImage} alt="Preview" className="w-32 h-32 object-cover rounded-md" />
          </div>
        )}
        <button
          onClick={handleImageUpload}
          className="w-full py-2 text-white bg-blue-500 rounded-lg hover:bg-blue-600 focus:outline-none focus:ring focus:ring-blue-300"
        >
          Upload Image
        </button>

        {uploadedImage && (
          <div className="mt-6 text-center">
            <h3 className="text-lg font-bold">Uploaded Image:</h3>
            <img src={uploadedImage} alt="Uploaded" className="w-32 h-32 object-cover rounded-md mx-auto" />
          </div>
        )}

        <button
          onClick={handleNavigate}
          className="mt-4 w-full py-2 text-white bg-green-500 rounded-lg hover:bg-green-600 focus:outline-none focus:ring focus:ring-green-300"
        >
          Go to Contents
        </button>
      </div>
    </div>
  );
}
