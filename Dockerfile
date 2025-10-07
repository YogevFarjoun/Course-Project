# ---- שלב 1: Build ----
FROM node:20-alpine AS build
WORKDIR /app

# העתקת קבצי המניפסט והתקנת תלויות
COPY package*.json ./
RUN npm ci

# העתקת קוד ובנייה
COPY . .
RUN npm run build

# ---- שלב 2: Serve ב-Nginx ----
FROM nginx:alpine

# העתקת קובץ הקונפיגורציה המותאם
COPY nginx.conf /etc/nginx/nginx.conf

# העתקת פלט ה-build של Vite
COPY --from=build /app/dist /usr/share/nginx/html

# פתיחת הפורט
EXPOSE 80

# הפעלת Nginx
CMD ["nginx", "-g", "daemon off;"]