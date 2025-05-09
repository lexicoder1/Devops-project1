'use client';

import { useEffect, useState } from "react";
import Link from "next/link";

export async function fetchPublicContent() {
  return [
    { id: 1, type: "image", url: "https://via.placeholder.com/150", uploader: "User1" },
    { id: 2, type: "image", url: "https://via.placeholder.com/200", uploader: "User2" },
    { id: 3, type: "image", url: "https://via.placeholder.com/250", uploader: "User3" },
    { id: 4, type: "image", url: "https://via.placeholder.com/250", uploader: "User4" },
    { id: 5, type: "image", url: "https://via.placeholder.com/250", uploader: "User5" },
  ];
}

export default function PublicContentPage() {
  const [publicContent, setPublicContent] = useState([]);
  const [filteredContent, setFilteredContent] = useState([]);
  const [searchQuery, setSearchQuery] = useState("");
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchContent = async () => {
      try {
        const content = await fetchPublicContent();
        setPublicContent(content);
        setFilteredContent(content);
      } catch (err) {
        setError("Failed to fetch content. Please try again.");
      } finally {
        setLoading(false);
      }
    };

    fetchContent();
  }, []);

  const handleSearch = (e) => {
    const query = e.target.value.toLowerCase();
    setSearchQuery(query);

    const filtered = publicContent.filter((content) =>
      content.uploader.toLowerCase().includes(query)
    );

    setFilteredContent(filtered);
  };

  if (loading) {
    return <div className="flex items-center justify-center h-screen">Loading...</div>;
  }

  if (error) {
    return <div className="flex items-center justify-center h-screen">{error}</div>;
  }

  return (
    <div className="relative flex flex-col items-center min-h-screen bg-gray-100 px-4">
      {/* Sticky Navigation Bar */}
      <div className="sticky top-0 z-10 flex justify-between w-full max-w-4xl bg-white shadow-md p-4 rounded-b-lg">
        <Link
          href="/"
          className="px-4 py-2 text-sm font-bold text-white bg-blue-500 rounded-lg hover:bg-blue-600 focus:outline-none focus:ring focus:ring-blue-300"
        >
          🏠 Home
        </Link>
        <Link
          href="/upload"
          className="px-4 py-2 text-sm font-bold text-white bg-green-500 rounded-lg hover:bg-green-600 focus:outline-none focus:ring focus:ring-green-300"
        >
          ⬆️ Upload
        </Link>
      </div>

      {/* Content Wrapper */}
      <div className="w-full max-w-2xl mt-4 p-4 bg-white rounded-lg shadow-md">
        <h2 className="mb-4 text-xl font-bold text-center">Publicly Uploaded Content</h2>

        {/* Search Input */}
        <div className="mb-4">
          <input
            type="text"
            value={searchQuery}
            onChange={handleSearch}
            placeholder="Search by uploader's name"
            className="w-full p-2 border border-gray-300 rounded-lg focus:ring focus:ring-blue-300"
          />
        </div>

        {filteredContent.length > 0 ? (
          <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 md:grid-cols-3">
            {filteredContent.map((content) => (
              <div key={content.id} className="text-center">
                {content.type === "image" && (
                  <>
                    <img
                      src={content.url}
                      alt={`Uploaded by ${content.uploader}`}
                      className="w-full h-32 object-cover rounded-md"
                    />
                    <p className="mt-2 text-sm text-gray-600">
                      Uploaded by: <span className="font-bold">{content.uploader}</span>
                    </p>
                  </>
                )}
              </div>
            ))}
          </div>
        ) : (
          <p className="text-center text-gray-600">No content found for the search query.</p>
        )}
      </div>
    </div>
  );
}