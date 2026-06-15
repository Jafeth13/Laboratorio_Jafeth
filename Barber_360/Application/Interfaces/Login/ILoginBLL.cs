using Domain.Entidades.LoginResponse;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Application.Interfaces.Login
{
    public interface ILoginBLL
    {
        Task<LoginResponseETL> Login(string email, string password);

    }
}
