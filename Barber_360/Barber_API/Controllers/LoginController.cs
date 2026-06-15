using Application.Interfaces.Login;
using Microsoft.AspNetCore.Identity.Data;
using Microsoft.AspNetCore.Mvc;

namespace Barber_API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class LoginController : Controller
    {
        private readonly ILoginBLL _loginBLL;

        public LoginController(ILoginBLL loginBLL)
        {
            _loginBLL = loginBLL;
        }

        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] LoginRequest request)
        {
            if (string.IsNullOrEmpty(request.Email) || string.IsNullOrEmpty(request.Password))
            {
                return BadRequest("Email y contraseña son requeridos");
            }

            var response = await _loginBLL.Login(request.Email, request.Password);

            if (!response.Success)
            {
                return Unauthorized(response);
            }

            return Ok(response);
        }

    }
}
