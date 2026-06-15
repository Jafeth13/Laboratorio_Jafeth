using Application.Interfaces;
using Application.Interfaces.RegisterUser;
using Application.Servicios;
using Domain.Entidades.RegisterRequest;
using Domain.Entidades.User;
using Microsoft.AspNetCore.Identity.Data;
using Microsoft.AspNetCore.Mvc;

namespace Barber_API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class RegisterUserController : Controller
    {
        private readonly IRegisterUserBLL registerBLL;

        public RegisterUserController(IRegisterUserBLL userService)
        {
            registerBLL = userService;
        }

        [HttpPost("register")]
        public async Task<IActionResult> Register([FromBody] RegisterRequestETL request)
        {
            if (
                string.IsNullOrEmpty(request.Email) ||
                string.IsNullOrEmpty(request.Password) 
                )
            {
                return BadRequest("Name, Email, Password y Role son requeridos");
            }

            var response = await registerBLL.Register(request);

            if (!response.Success)
            {
                return BadRequest(response);
            }

            return Ok(response);
        }
    }
}
