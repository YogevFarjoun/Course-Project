# ---- שלב 1: Build ----
FROM node:20-alpine AS build
WORKDIR /app

# התקנת תלויות
COPY package*.json ./
RUN npm ci

# העתקת קוד ובנייה
COPY . .
RUN npm run build

# ---- שלב 2: Serve באמצעות Nginx ----
FROM nginx:alpine

# העתקת קובץ קונפיגורציה מותאם אישית (ל-SPA כמו React/Vite)
COPY nginx.conf /etc/nginx/nginx.conf

# העתקת הקבצים שנבנו מהשלב הראשון
COPY --from=build /app/dist /usr/share/nginx/html

# פתיחת הפורט
EXPOSE 80

# הרצת Nginx במצב foreground
CMD ["nginx", "-g", "daemon off;"]