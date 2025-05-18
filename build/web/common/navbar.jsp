<%-- 
    Document   : navbar
    Created on : May 11, 2025, 8:16:36 PM
    Author     : Asus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Modern Website</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background-color: #f8f9fa;
        }

        header {
            background: linear-gradient(to right, #4d4dff, #4d94ff);
            color: white;
            padding: 1.5rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            position: relative;
            z-index: 100;
            flex-wrap: wrap;
        }

        .logo {
            display: flex;
            align-items: center;
        }

        .logo img {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            object-fit: cover;
            margin-right: 3rem;
            box-shadow: 0 0 10px rgba(255, 255, 255, 0.5);
        }

        .logo h1 {
            font-size: 1.5rem;
            font-weight: 600;
            letter-spacing: 1px;
        }

        .nav-main {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex: 1;
            margin-left: 3rem;
        }

        .menu,
        .login {
            display: flex;
            list-style: none;
            align-items: center;
        }

        .menu li,
        .login li {
            margin-left: 1.5rem;
            position: relative;
        }

        .menu li a,
        .login li a {
            color: white;
            text-decoration: none;
            font-weight: 500;
            font-size: 1rem;
            padding: 0.5rem 0;
            transition: all 0.3s ease;
        }

        .menu li a:hover,
        .login li a:hover {
            color: #ffdd00;
        }

        .menu li a::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 0;
            height: 2px;
            background-color: #ffdd00;
            transition: width 0.3s ease;
        }

        .menu li a:hover::after {
            width: 100%;
        }

        /* Login Button Special Styling */
        .login li a {
            background-color: rgba(255, 255, 255, 0.2);
            padding: 0.5rem 1.2rem;
            border-radius: 20px;
            border: 1px solid rgba(255, 255, 255, 0.3);
        }

        .login li a:hover {
            background-color: white;
            color: #4d4dff;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        /* Mobile menu button - hidden by default */
        .mobile-menu-btn {
            display: none;
            background: none;
            border: none;
            color: white;
            font-size: 1.5rem;
            cursor: pointer;
        }

        /* Animation for logo */
        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }

        .logo img:hover {
            animation: pulse 1.5s infinite;
        }

        /* Media Queries */
        @media screen and (max-width: 768px) {
            header {
                flex-direction: column;
                align-items: flex-start;
            }

            .mobile-menu-btn {
                display: block;
                margin-left: auto;
            }

            .nav-main {
                width: 100%;
                flex-direction: column;
                align-items: flex-start;
                display: none;
            }

            .nav-main.active {
                display: flex;
            }

            .menu,
            .login {
                flex-direction: column;
                width: 100%;
                padding-left: 1rem;
            }

            .menu li,
            .login li {
                margin: 0.5rem 0;
            }

            .menu li a::after {
                display: none;
            }

            .login li a {
                margin-top: 0.5rem;
            }
        }
    </style>
</head>
<body>
    <header>
        <div class="logo">
            <img src="images/logo.jpg" alt="Logo">
            <h1>E-Health</h1>
        </div>

        <button class="mobile-menu-btn">☰</button>

        <nav id="mainNav" class="nav-main">
            <ul class="menu">
                <li><a href="index.jsp">Home</a></li>
                <li><a href="about.jsp">About Us</a></li>
                <li><a href="services.jsp">Services</a></li>
                <li><a href="contact.jsp">Contact</a></li>
            </ul>
            <ul class="login">
                <li><a href="login.jsp">Login</a></li>
            </ul>
        </nav>
    </header>

    <!-- Main Content -->
    <main>
        <!-- Your page content -->
    </main>

    <script>
        // Toggle navigation on mobile
        document.querySelector('.mobile-menu-btn').addEventListener('click', function () {
            document.getElementById('mainNav').classList.toggle('active');
        });
    </script>
</body>
</html>

