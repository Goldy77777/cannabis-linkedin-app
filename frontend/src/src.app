import React, { useState, useEffect } from "react";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Tabs, TabsList, TabsTrigger, TabsContent } from "@/components/ui/tabs";
import { Avatar, AvatarImage, AvatarFallback } from "@/components/ui/avatar";

const API_BASE = "http://localhost:3001";

const useAuth = () => {
  const [user, setUser] = useState(null);
  const [token, setToken] = useState(null);

  const login = async (email, password) => {
    const res = await fetch(`${API_BASE}/auth/login`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ email, password })
    });
    const data = await res.json();
    if (data.token) {
      localStorage.setItem("token", data.token);
      setToken(data.token);
      fetchUser(data.token);
    }
  };

  const logout = () => {
    setUser(null);
    setToken(null);
    localStorage.removeItem("token");
  };

  const fetchUser = async (jwt) => {
    const res = await fetch(`${API_BASE}/users/me`, {
      headers: { Authorization: `Bearer ${jwt}` }
    });
    const data = await res.json();
    setUser(data);
  };

  useEffect(() => {
    const saved = localStorage.getItem("token");
    if (saved) {
      setToken(saved);
      fetchUser(saved);
    }
  }, []);

  return { user, token, login, logout };
};

const ProfileCard = ({ user }) => (
  <Card className="w-full max-w-md shadow-xl rounded-2xl p-4">
    <CardContent className="flex flex-col items-center gap-4">
      <Avatar className="h-20 w-20">
        <AvatarImage src="/user.png" />
        <AvatarFallback>{user?.name?.slice(0, 2) || "JD"}</AvatarFallback>
      </Avatar>
      <h2 className="text-xl font-bold">{user?.name}</h2>
      <p className="text-muted-foreground">{user?.title} @ {user?.company}</p>
      <Button className="w-full mt-2">Connect</Button>
    </CardContent>
  </Card>
);

const EditProfileForm = ({ token, refreshUser }) => {
  const [name, setName] = useState("");
  const [title, setTitle] = useState("");
  const [company, setCompany] = useState("");

  const save = async () => {
    await fetch(`${API_BASE}/users/me`, {
      method: "PUT",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`
      },
      body: JSON.stringify({ name, title, company })
    });
    refreshUser();
  };

  return (
    <Card className="max-w-md shadow-md rounded-2xl p-4">
      <CardContent className="flex flex-col gap-4">
        <h3 className="text-xl font-semibold">Edit Profile</h3>
        <Input placeholder="Full Name" value={name} onChange={(e) => setName(e.target.value)} />
        <Input placeholder="Job Title" value={title} onChange={(e) => setTitle(e.target.value)} />
        <Input placeholder="Company" value={company} onChange={(e) => setCompany(e.target.value)} />
        <Button onClick={save}>Save Changes</Button>
      </CardContent>
    </Card>
  );
};

const JobPost = () => (
  <Card className="w-full max-w-md shadow-lg rounded-2xl p-4">
    <CardContent>
      <h3 className="text-lg font-semibold">Budtender - HighTime Dispensary</h3>
      <p className="text-sm text-muted-foreground">Denver, CO · Full-time</p>
      <Button className="mt-2">Apply</Button>
    </CardContent>
  </Card>
);

const CertificationUpload = () => (
  <Card className="max-w-lg shadow-md rounded-2xl p-4">
    <CardContent className="flex flex-col gap-4">
      <h3 className="text-xl font-semibold">Submit Certification</h3>
      <Input placeholder="Certification Title" />
      <Textarea placeholder="Description or Authority" />
      <Button>Upload</Button>
    </CardContent>
  </Card>
);

const Connections = () => (
  <Card className="w-full max-w-md shadow-md rounded-2xl p-4">
    <CardContent className="space-y-3">
      <h3 className="text-xl font-semibold">Connections</h3>
      <div className="flex justify-between items-center">
        <span>John Green</span>
        <Button size="sm">Message</Button>
      </div>
      <div className="flex justify-between items-center">
        <span>Alicia Stone</span>
        <Button size="sm">Message</B
