import { sql } from "drizzle-orm";
import { pgTable, text, varchar, real, jsonb } from "drizzle-orm/pg-core";
import { createInsertSchema } from "drizzle-zod";
import { z } from "zod";

export const users = pgTable("users", {
  id: varchar("id").primaryKey().default(sql`gen_random_uuid()`),
  username: text("username").notNull().unique(),
  password: text("password").notNull(),
});

export const insertUserSchema = createInsertSchema(users).pick({
  username: true,
  password: true,
});

export type InsertUser = z.infer<typeof insertUserSchema>;
export type User = typeof users.$inferSelect;

// Estate management types
export interface Coordinate {
  lat: number;
  lng: number;
}

export interface Field {
  id: string;
  name: string;
  area: number;
  coordinates: Coordinate[];
}

export interface Section {
  id: string;
  name: string;
  fields: Field[];
}

export interface Estate {
  id: string;
  estateName: string;
  description: string;
  manager: string;
  location: string;
  sections: Section[];
}

export interface HighlightedField {
  fieldId: string;
  geoLocation: Coordinate;
}
