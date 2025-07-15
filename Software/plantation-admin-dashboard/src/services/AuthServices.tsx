// src/services/authService.ts
import {
  onAuthStateChanged,
  signInWithEmailAndPassword,
  createUserWithEmailAndPassword,
  signInWithPopup,
  GoogleAuthProvider,
  signOut,
  type User
} from "firebase/auth";
import {
  doc,
  getDoc,
  setDoc
} from "firebase/firestore";

// ✅ Import shared instances
import { auth, db } from "../utils/firebase";

export const createUserDocumentIfNotExists = async (user: User) => {
  const userDocRef = doc(db, "users", user.uid);
  const docSnap = await getDoc(userDocRef);
  if (!docSnap.exists()) {
    await setDoc(userDocRef, {
      email: user.email,
      role: "user",
    });
  }
};

export const registerWithEmail = async (email: string, password: string) => {
  const result = await createUserWithEmailAndPassword(auth, email, password);
  await createUserDocumentIfNotExists(result.user);
  return result.user;
};

export const loginWithEmail = async (email: string, password: string) => {
  const result = await signInWithEmailAndPassword(auth, email, password);
  await createUserDocumentIfNotExists(result.user);
  return result.user;
};

export const loginWithGoogle = async () => {
  const provider = new GoogleAuthProvider();
  const result = await signInWithPopup(auth, provider);
  await createUserDocumentIfNotExists(result.user);
  return result.user;
};

export const logout = async () => {
  await signOut(auth);
};

export const authStateListener = (callback: (user: User | null) => void) => {
  return onAuthStateChanged(auth, callback);
};
